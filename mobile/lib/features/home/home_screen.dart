import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/api_service.dart';
import '../../core/repositories/ad_repository.dart';
import '../../models/ad_model.dart';
import 'ad_detail_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/widgets/shimmer_loaders.dart';
import '../../core/widgets/offline_banner.dart';
import '../../core/services/favorites_provider.dart';
import '../../core/services/image_cache_manager.dart';
import '../../core/nav_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/banner_carousel.dart';
import '../auth/auth_provider.dart';
import '../notifications/notification_screen.dart';
import '../notifications/notification_provider.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool _isLoading = true;
  List<AdModel> _ads = [];
  List<AdModel> _filteredAds = [];
  List<dynamic> _categories = [];
  String _error = '';
  
  String _selectedCategory = 'all';
  String _selectedCity = 'Todas';
  String _searchQuery = '';
  
  final List<String> _cities = ['Todas', 'Ocaña', 'Cúcuta', 'Abrego', 'Convención', 'Aguachica'];

  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 12;
  bool _hasMorePages = true;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _searchLayerLink = LayerLink();
  OverlayEntry? _suggestionsOverlayEntry;
  List<dynamic> _suggestions = [];
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_isFetchingMore &&
          _hasMorePages) {
        _fetchMoreAds();
      }
    });
  }

  void _onSearchFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      // Small delay to allow onTap on suggestions to fire before hiding
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && !_searchFocusNode.hasFocus) {
          _hideSuggestions();
        }
      });
    } else if (_searchController.text.isNotEmpty) {
      _showSuggestions();
    }
  }

  void _showSuggestions() {
    _hideSuggestions(); // Ensure no duplicates
    if (_suggestions.isEmpty) return;
    
    _suggestionsOverlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_suggestionsOverlayEntry!);
  }

  void _hideSuggestions() {
    _suggestionsOverlayEntry?.remove();
    _suggestionsOverlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width - 40, // Match search bar width (padding considered)
        child: CompositedTransformFollower(
          link: _searchLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 52), // Just below search bar
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFF0E2244).withOpacity(0.98), // Premium Navy Glass
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      suggestion['title'],
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      suggestion['category_name'] ?? '',
                      style: GoogleFonts.outfit(color: const Color(0xFFE2E000).withOpacity(0.8), fontSize: 10),
                    ),
                    onTap: () {
                      try {
                        final selectedAd = AdModel.fromJson(suggestion);
                        _hideSuggestions();
                        _searchFocusNode.unfocus();
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => AdDetailScreen(ad: selectedAd))
                        );
                      } catch (e) {
                        _hideSuggestions();
                        _searchFocusNode.unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al abrir establecimiento: $e'),
                            backgroundColor: Colors.red[800],
                          )
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    _hideSuggestions();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      _fetchAds(),
      _fetchCategories(),
    ]);
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _categories = [
        {'name': 'Todos', 'slug': 'all', 'icon': Icons.grid_view},
        {'name': 'Salud', 'slug': 'salud', 'icon': Icons.medical_services_outlined},
        {'name': 'Gastronomía', 'slug': 'gastronomia', 'icon': Icons.restaurant},
        {'name': 'Tecnología', 'slug': 'tecnologia', 'icon': Icons.smartphone},
        {'name': 'Hogar', 'slug': 'hogar', 'icon': Icons.home_outlined},
        {'name': 'Servicios', 'slug': 'servicios', 'icon': Icons.handyman_outlined},
        {'name': 'Vehículos', 'slug': 'vehiculos', 'icon': Icons.directions_car_outlined},
        {'name': 'Inmuebles', 'slug': 'inmuebles', 'icon': Icons.location_city_outlined},
        {'name': 'Moda', 'slug': 'moda', 'icon': Icons.face_retouching_natural_outlined},
      ];
    });
  }

  Future<void> _fetchAds() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMorePages = true;
      _error = '';
    });
    try {
      final response = await context.read<AdRepository>().fetchAds(
            category: _selectedCategory,
            city: _selectedCity == 'Todas' ? 'all' : _selectedCity,
            query: _searchQuery,
            page: 1,
            limit: _pageSize,
          );

      if (response.data['success'] == true) {
        final List<dynamic> adsJson = response.data['data']['ads'];
        setState(() {
          _ads = adsJson.map((json) => AdModel.fromJson(json)).toList();
          _filteredAds = List.from(_ads);
          _hasMorePages = adsJson.length == _pageSize;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _error = 'Sin conexión con el servidor');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMoreAds() async {
    if (_isFetchingMore || !_hasMorePages) return;
    setState(() => _isFetchingMore = true);
    try {
      final nextPage = _currentPage + 1;
      final response = await context.read<AdRepository>().fetchAds(
            category: _selectedCategory,
            city: _selectedCity == 'Todas' ? 'all' : _selectedCity,
            query: _searchQuery,
            page: nextPage,
            limit: _pageSize,
          );
      if (response.data['success'] == true) {
        final List<dynamic> adsJson = response.data['data']['ads'];
        setState(() {
          _currentPage = nextPage;
          _ads.addAll(adsJson.map((json) => AdModel.fromJson(json)));
          _filteredAds = List.from(_ads);
          _hasMorePages = adsJson.length == _pageSize;
        });
      }
    } catch (e) {
      debugPrint('Fetch more ads error: $e');
    } finally {
      setState(() => _isFetchingMore = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
      _fetchAds();
      
      if (query.length >= 2) {
        _fetchSuggestions(query);
      } else {
        setState(() => _suggestions = []);
        _hideSuggestions();
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    try {
      final response = await context.read<AdRepository>().fetchSuggestions(query);

      if (response.data != null && response.data['ads'] != null) {
        setState(() {
          _suggestions = response.data['ads'];
        });
        if (_searchFocusNode.hasFocus) {
          _showSuggestions();
        }
      }
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
    }
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text('SELECCIONA TU CIUDAD', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF0E2244), letterSpacing: 2)),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 40),
                  itemCount: _cities.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final city = _cities[index];
                    final isSelected = _selectedCity == city;
                    return ListTile(
                      onTap: () {
                        setState(() => _selectedCity = city);
                        Navigator.pop(context);
                        _fetchAds();
                      },
                      leading: Icon(Icons.location_on_outlined, color: isSelected ? Colors.blue : Colors.grey),
                      title: Text(city, style: GoogleFonts.inter(fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500, color: isSelected ? Colors.blue : const Color(0xFF0E2244))),
                      trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.blue) : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(
      controller: kIsWeb ? null : _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      primary: kIsWeb,
      slivers: [
          // 1. Custom Sliver App Bar (Title & Actions)
          SliverAppBar(
            pinned: true,
            floating: kIsWeb ? false : true,
            elevation: 0,
            toolbarHeight: 70,
            expandedHeight: 70, // Consistent height avoids off-screen rendering
            backgroundColor: const Color(0xFFE2E000), // KLICUS Yellow
            surfaceTintColor: const Color(0xFFE2E000),
            title: Text(
              'KLICUS', 
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900, 
                fontSize: 22, 
                color: const Color(0xFF0E2244),
                letterSpacing: -1.0,
              ),
            ),
            actions: [
              _buildNotificationAction(),
              _buildUserAvatarAction(),
            ],
          ),

          // 2 & 3. Attraction Zone: Search Bar & Promo Banner with Gradient
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFE2E000), // KLICUS Yellow
                    Color(0xFFF8F9FB), // Neutral Background
                  ],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CompositedTransformTarget(
                            link: _searchLayerLink,
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white, // Pop from gradient
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.white.withOpacity(0.5)),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                onChanged: _onSearchChanged,
                                decoration: const InputDecoration(
                                  hintText: 'Busca productos o servicios...',
                                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search, color: Color(0xFF0E2244), size: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _showCityPicker,
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E2244), // Contrast color for picker
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.white),
                                  const SizedBox(width: 6),
                                  Text(
                                    _selectedCity == 'Todas' ? 'Ciudad' : _selectedCity,
                                    style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const BannerCarousel(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          // 4. Categories Bar (Sticky/Pinned)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverCategoryDelegate(
              child: Container(
                color: const Color(0xFFF8F9FB), // Neutral Background
                padding: const EdgeInsets.only(top: 10),
                child: _buildCategoryBar(),
              ),
            ),
          ),

          // 5. Main Gallery (Sliver Grid)
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: _isLoading
              ? const SliverToBoxAdapter(child: ShimmerAdGrid())
              : _error.isNotEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.08), blurRadius: 20)],
                              ),
                              child: Icon(Icons.wifi_off_rounded, size: 48, color: Colors.red[300]),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'SIN CONEXIÓN',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF0E2244), letterSpacing: 2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[500], height: 1.5),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: _fetchAds,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: Text('REINTENTAR', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0E2244),
                                foregroundColor: const Color(0xFFE2E000),
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              : _filteredAds.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(Icons.search_off_rounded, size: 48, color: const Color(0xFF0E2244).withOpacity(0.2)),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'SIN RESULTADOS',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0E2244).withOpacity(0.4),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Intenta buscar algo diferente\no explora otra categoría.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey[500],
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 60), // Offset visual
                        ],
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: _AdCard(ad: _filteredAds[index]),
                            ),
                          ),
                        );
                      },
                      childCount: _filteredAds.length,
                    ),
                  ),
          ),
          SliverToBoxAdapter(
            child: _isFetchingMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0E2244),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : const SizedBox(height: 100),
          ),
        ],
      );

    final Widget mainContent = kIsWeb ? scrollView : AnimationLimiter(child: scrollView);

    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: kIsWeb
                ? mainContent
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _fetchAds,
                    color: const Color(0xFF0E2244),
                    child: mainContent,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationAction() {
    return Consumer<NotificationProvider>(
      builder: (context, notifProv, child) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0E2244), size: 22),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
              },
            ),
          ),
          if (notifProv.unreadCount > 0)
            Positioned(
              top: 15,
              right: 18,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserAvatarAction() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final user = auth.currentUser;
        final bool isAuth = auth.isAuthenticated;
        
        // Extract initials if logged in
        String initials = '';
        if (isAuth && user?['name'] != null) {
          List<String> names = user!['name'].toString().split(' ');
          if (names.isNotEmpty) {
            initials = names[0][0].toUpperCase();
            if (names.length > 1 && names[1].isNotEmpty) {
              initials += names[1][0].toUpperCase();
            }
          }
        }

        return GestureDetector(
          onTap: () => context.read<NavigationProvider>().setIndex(2),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: isAuth ? [
                  BoxShadow(
                    color: const Color(0xFFE2E000).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ] : [],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: isAuth ? Colors.white : Colors.grey[100],
                backgroundImage: (isAuth && user?['avatar_url'] != null && user!['avatar_url'].toString().isNotEmpty) 
                  ? CachedNetworkImageProvider(ApiService.normalizeUrl(user!['avatar_url']), cacheManager: KlicusCacheManager.instance)
                  : null,
                child: (isAuth && (user?['avatar_url'] == null || user!['avatar_url'].toString().isEmpty))
                  ? Text(
                      initials,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF0E2244),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    )
                  : (!isAuth) 
                    ? const Icon(Icons.person_outline_rounded, color: Colors.grey, size: 22) 
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(bottom: 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['slug'];
          
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat['slug']);
              _fetchAds();
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.only(right: 16, bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0E2244) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey[200]!,
                      width: 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: const Color(0xFF0E2244).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ] : [],
                  ),
                  child: Icon(
                    cat['icon'], 
                    color: isSelected ? const Color(0xFFE2E000) : Colors.grey[400],
                    size: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    cat['name'],
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                      color: isSelected ? const Color(0xFF0E2244) : Colors.grey[500],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AdCard extends StatelessWidget {
  final AdModel ad;
  const _AdCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    final bool isDiamond = ad.priorityLevel == 'diamond';
    final bool isPro = ad.priorityLevel == 'pro';

    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFC), // Premium Card Background
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (isDiamond)
            BoxShadow(
              color: const Color(0xFFE2E000).withOpacity(0.2), // Diamond Glow
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: ApiService.normalizeUrl(ad.firstImage),
                        cacheManager: KlicusCacheManager.instance,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[50]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[50],
                          child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                        ),
                      ),
                      if (isDiamond)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15), // Glass effect
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.6), width: 1), // Metallic border
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.diamond_outlined, color: Color(0xFF0E2244), size: 10),
                                    const SizedBox(width: 4),
                                    const Text('ELITE', 
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF0E2244), letterSpacing: 0.5)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (isPro)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0E2244).withOpacity(0.65), // Blue Glass effect
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1), // Light border
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.white, size: 10),
                                    const SizedBox(width: 4),
                                    const Text('PRO', 
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900, 
                          fontSize: 14, 
                          color: const Color(0xFF0E2244), 
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 10, color: Color(0xFFE2E000)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              ad.location,
                              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isDiamond)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFDB931)], // Metallic gold accent
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (isDiamond) {
      cardContent = _DiamondShine(child: cardContent);
    }

    return Consumer<FavoritesProvider>(
      builder: (context, favs, _) {
        final isFav = favs.isFavorite(ad.id.toString());
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdDetailScreen(ad: ad)));
          },
          child: Stack(
            children: [
              cardContent,
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => favs.toggle(ad.id.toString()),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)
                      ],
                    ),
                    child: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 16,
                      color: isFav ? Colors.red[400] : Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DiamondShine extends StatefulWidget {
  final Widget child;
  const _DiamondShine({required this.child});

  @override
  State<_DiamondShine> createState() => _DiamondShineState();
}

class _DiamondShineState extends State<_DiamondShine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                if (!_controller.isAnimating) return const SizedBox.shrink();
                return ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: FractionallySizedBox(
                    widthFactor: 2.0,
                    alignment: Alignment(_animation.value, 0),
                    child: Transform.rotate(
                      angle: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.4, 0.5, 0.6],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SliverCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverCategoryDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF8F9FB), // Neutral Background
      child: child,
    );
  }

  @override
  double get maxExtent => 110.0;

  @override
  double get minExtent => 110.0;

  @override
  bool shouldRebuild(covariant _SliverCategoryDelegate oldDelegate) {
    return true; // Force refresh if rebuilt to ensure height sync
  }
}
