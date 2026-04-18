import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/api_service.dart';
import '../../models/ad_model.dart';
import 'ad_detail_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/widgets/shimmer_loaders.dart';
import '../../core/nav_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/banner_carousel.dart';
import '../auth/auth_provider.dart';
import '../notifications/notification_screen.dart';
import '../notifications/notification_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<AdModel> _ads = [];
  List<AdModel> _filteredAds = [];
  List<dynamic> _categories = [];
  String _error = '';
  
  String _selectedCategory = 'all';
  String _selectedCity = 'Todas';
  String _searchQuery = '';
  
  final List<String> _cities = ['Todas', 'Ocaña', 'Cúcuta', 'Abrego', 'Convención', 'Aguachica'];

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
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
    setState(() => _isLoading = true);
    try {
      final api = context.read<ApiService>();
      final response = await api.get('/pautas', queryParameters: {
        'category': _selectedCategory,
        'city': _selectedCity == 'Todas' ? 'all' : _selectedCity,
        'q': _searchQuery,
      });
      
      if (response.data['success'] == true) {
        final List<dynamic> adsJson = response.data['data']['ads'];
        setState(() {
          _ads = adsJson.map((json) => AdModel.fromJson(json)).toList();
          _filteredAds = List.from(_ads); // Now server handles filtering
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _error = 'Sin conexión con el servidor');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
      _fetchAds();
    });
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: const Border(
              bottom: BorderSide(color: Color(0xFFE2E000), width: 2), // Acento Amarillo Elite
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                title: Text(
                  'KLICUS', 
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900, 
                    fontSize: 26, 
                    letterSpacing: -1.5,
                    color: const Color(0xFF0E2244),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                toolbarHeight: 70,
                actions: [
                  Consumer<NotificationProvider>(
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
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      final user = auth.currentUser;
                      final bool isAuth = auth.isAuthenticated;
                      
                      return GestureDetector(
                        onTap: () => context.read<NavigationProvider>().setIndex(2),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE2E000).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFE2E000),
                              backgroundImage: (isAuth && user?['avatar_url'] != null) 
                                ? CachedNetworkImageProvider(ApiService.normalizeUrl(user!['avatar_url'])) 
                                : null,
                              child: (!isAuth || user?['avatar_url'] == null) 
                                ? const Icon(Icons.person_outline_rounded, color: Color(0xFF0E2244), size: 22) 
                                : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar & City Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: TextField(
                      controller: _searchController,
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
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _showCityPicker,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E000),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Color(0xFF0E2244)),
                          const SizedBox(width: 6),
                          Text(
                            _selectedCity == 'Todas' ? 'Ciudad' : _selectedCity,
                            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w900, color: const Color(0xFF0E2244)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 2. Promo Banner
          const BannerCarousel(),
          
          // 3. Categories
          _buildCategoryBar(),
          
          // 3. Main Marketplace Grid
          Expanded(
            child: _isLoading 
              ? const ShimmerAdGrid()
              : _filteredAds.isEmpty
                ? const Center(child: Text('No se encontraron resultados', style: TextStyle(color: Colors.grey)))
                : RefreshIndicator(
                    onRefresh: _fetchAds,
                    child: AnimationLimiter(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredAds.length,
                        itemBuilder: (context, index) {
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
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 90,
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
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AdDetailScreen(ad: ad)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
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
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[50]),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[50],
                        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                      ),
                    ),
                    if (ad.priorityLevel == 'diamond')
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E000),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                          ),
                          child: const Text('ELITE', 
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF0E2244))),
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
                        color: const Color(0xFF0E2244), // Contrast Fix: Navy instead of Yellow
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
      ),
    );
  }
}
