import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../core/api_service.dart';
import '../../models/ad_model.dart';
import '../auth/auth_provider.dart';
import '../profile/edit_ad_screen.dart';
import '../profile/upgrade_ad_screen.dart';
import '../../core/services/push_service.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/chat_service.dart';
import '../../core/services/favorites_provider.dart';
import '../../core/services/image_cache_manager.dart';
import '../../features/chat/chat_detail_screen.dart';

class AdDetailScreen extends StatefulWidget {
  final AdModel ad;
  const AdDetailScreen({super.key, required this.ad});

  @override
  State<AdDetailScreen> createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isStartingChat = false;

  @override
  void initState() {
    super.initState();
    _trackView();
  }

  void _trackView() {
    try {
      final analytics = context.read<AnalyticsService>();
      analytics.trackEvent(adId: widget.ad.id, eventType: 'view');
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  Future<void> _shareAd() async {
    final String shareText = '¡Mira este anuncio en KLICUS!\n\n${widget.ad.title}\n${widget.ad.location}\n\nEncuentra más en la App de KLICUS.';
    try {
      final analytics = context.read<AnalyticsService>();
      await analytics.trackEvent(adId: widget.ad.id, eventType: 'share');
      await Share.share(shareText, subject: 'Compartir Anuncio KLICUS');
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  Future<void> _launchUrl(String url, String eventType) async {
    try {
       final analytics = context.read<AnalyticsService>();
       await analytics.trackEvent(adId: widget.ad.id, eventType: eventType);
       
       if (await canLaunchUrl(Uri.parse(url))) {
         await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
       }
    } catch (e) {
      debugPrint('Launch error: $e');
    }
  }

  Future<void> _startChat(BuildContext context) async {
    if (_isStartingChat) return;
    
    final auth = context.read<AuthProvider>();
    final apiService = context.read<ApiService>();
    final navy = const Color(0xFF0E2244);
    final yellow = const Color(0xFFE2E000);

    debugPrint('Iniciando Chat - Autenticado: ${auth.isAuthenticated}');

    // If not authenticated, ask for a name instead of blocking
    if (!auth.isAuthenticated) {
      final String? existingGuestId = await apiService.getGuestId();
      final String? existingGuestName = await apiService.getGuestName();
      debugPrint('Guest identity: ID=$existingGuestId, Name=$existingGuestName');
      
      if (existingGuestId == null || existingGuestName == null) {
        debugPrint('Mostrando Diálogo de Identidad a Invitado...');
        final TextEditingController nameController = TextEditingController();
        final bool? confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Force them to choose or cancel
          builder: (dialogContext) => AlertDialog(
            backgroundColor: navy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            title: Text('¡HABLEMOS! 👋', 
              style: GoogleFonts.outfit(color: yellow, fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dinos tu nombre para que el vendedor sepa con quién habla.', 
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Tu nombre o apodo',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.person_outline, color: yellow.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      child: Text('CANCELAR', style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: navy,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('EMPEZAR CHAT', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        debugPrint('Resultado de Diálogo: $confirmed, Nombre: ${nameController.text}');
        if (confirmed != true || nameController.text.trim().isEmpty) {
          debugPrint('Chat cancelado por el usuario o nombre vacío.');
          return;
        }
        
        final name = nameController.text.trim();
        await apiService.saveGuestData(name);
        if (!context.mounted) return;
        
        // Unified Push Registration
        await PushNotificationService.registerToken();
      }
    }

    if (widget.ad.ownerId == auth.currentUser?['id'].toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('NO PUEDES CHATEAR CONTIGO MISMO 🛡️', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          backgroundColor: navy,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isStartingChat = true);

    try {
      final chatService = ChatService(apiService);
      final response = await chatService.startConversation(widget.ad.id);
      
      if (mounted) setState(() => _isStartingChat = false);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final convId = response.data['conversationId'];
        
        // Track Chat Analytics Event
        try {
          final analytics = context.read<AnalyticsService>();
          await analytics.trackEvent(adId: widget.ad.id, eventType: 'chat');
        } catch(e) { debugPrint('Chat analytics track error: $e'); }

        if (mounted) {
           Navigator.push(context, MaterialPageRoute(builder: (_) => 
             ChatDetailScreen(conversation: {
               'id': convId,
               'ad_title': widget.ad.title,
               'seller_name': widget.ad.ownerName ?? 'VENDEDOR ELITE'
             })
           ));
        }
      } else {
        final errorMsg = response.data?['error'] ?? 'Error desconocido del servidor';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ERROR: $errorMsg ⚠️', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
              backgroundColor: Colors.red[800],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isStartingChat = false);
      debugPrint('Start Chat Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('FALLO DE CONEXIÓN AL CHAT: $e 📡', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red[900],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isOwner = auth.isAuthenticated && widget.ad.ownerId == auth.currentUser?['id'].toString();
    final navy = const Color(0xFF0E2244);
    final yellow = const Color(0xFFE2E000);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: CustomScrollView(
        slivers: [
          // HEADER GALLERY
          SliverAppBar(
            expandedHeight: 450,
            pinned: true,
            backgroundColor: navy,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: BackButton(color: navy),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (idx) => setState(() => _currentPage = idx),
                    itemCount: widget.ad.imageUrls.isNotEmpty ? widget.ad.imageUrls.length : 1,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: ApiService.normalizeUrl(widget.ad.imageUrls.isNotEmpty ? widget.ad.imageUrls[index] : widget.ad.firstImage),
                        cacheManager: KlicusCacheManager.instance,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      );
                    },
                  ),
                  // Gradient Overlay (Ignoring pointers to allow PageView drag)
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.3), Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                    ),
                  ),
                  // DOT INDICATORS (Ignoring pointers to allow PageView drag)
                  if (widget.ad.imageUrls.length > 1)
                    IgnorePointer(
                      ignoring: false, // Explicitly allow interaction for dots
                      child: Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.ad.imageUrls.length, (index) {
                            return GestureDetector(
                              onTap: () => _pageController.animateToPage(
                                index, 
                                duration: const Duration(milliseconds: 400), 
                                curve: Curves.easeInOutExpo
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), // More hit area
                                  width: _currentPage == index ? 24 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index 
                                      ? yellow 
                                      : Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favs, _) {
                  final isFav = favs.isFavorite(widget.ad.id.toString());
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red[400] : navy,
                        ),
                        onPressed: () => favs.toggle(widget.ad.id.toString()),
                      ),
                    ),
                  );
                },
              ),
              if (isOwner) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFE2E000),
                    child: IconButton(
                      icon: Icon(Icons.star_rounded, color: navy),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UpgradeAdScreen(ad: widget.ad))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: yellow,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: navy),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditAdScreen(ad: widget.ad))),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // CONTENT
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.ad.priorityLevel == 'diamond' || widget.ad.priorityLevel == 'pro') ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.ad.priorityLevel == 'diamond' ? yellow.withOpacity(0.15) : navy.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: widget.ad.priorityLevel == 'diamond' ? yellow : navy.withOpacity(0.3), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.ad.priorityLevel == 'diamond' ? Icons.diamond_outlined : Icons.star_rounded, 
                              color: navy, 
                              size: 12
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.ad.priorityLevel == 'diamond' ? 'ANUNCIO ELITE' : 'ANUNCIO PRO', 
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: navy, letterSpacing: 1)
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // TOP BAR: CATEGORY & DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E000).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.ad.categoryName.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: navy,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Text(
                          'PUBLICADO EL ${DateFormat.yMMMd().format(widget.ad.createdAt).toUpperCase()}',
                          style: GoogleFonts.outfit(
                            color: Colors.grey[400],
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // TITLE & LOCATION
                    Text(
                      widget.ad.title,
                      style: GoogleFonts.outfit(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: navy,
                        letterSpacing: -1.2,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: yellow),
                        const SizedBox(width: 6),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                color: Colors.grey[600], 
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              children: [
                                if (!widget.ad.location.toLowerCase().contains('ocaña') && 
                                    !widget.ad.location.toLowerCase().contains('aguachica') &&
                                    !widget.ad.location.toLowerCase().contains('abrego') &&
                                    !widget.ad.location.toLowerCase().contains('cúcuta') &&
                                    !widget.ad.location.toLowerCase().contains('bucaramanga') &&
                                    !widget.ad.location.contains(','))
                                  TextSpan(
                                    text: widget.ad.title.toLowerCase().contains('aguas') ? 'Aguachica • ' : 'Ocaña • ',
                                    style: TextStyle(color: navy, fontWeight: FontWeight.w900),
                                  ),
                                TextSpan(
                                  text: widget.ad.location,
                                  style: (!widget.ad.location.contains(',') && 
                                          (widget.ad.location.toLowerCase().contains('ocaña') || 
                                           widget.ad.location.toLowerCase().contains('aguachica')))
                                      ? TextStyle(color: navy, fontWeight: FontWeight.w900)
                                      : null,
                                ),
                                if (widget.ad.address != null && widget.ad.address!.isNotEmpty && widget.ad.address != widget.ad.location)
                                  TextSpan(text: ' • ${widget.ad.address}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    
                    // ACTION BAR (REDESIGNED)
                    _buildActionPanel(context, navy, yellow),

                    const SizedBox(height: 48),

                    // PREMIUM CONTACT BOX (IF PREMIUM)
                    if (widget.ad.priorityLevel == 'diamond' || widget.ad.priorityLevel == 'gold')
                      _buildEliteContactHub(navy, yellow),

                    const SizedBox(height: 40),
                    
                    // DESCRIPTION
                    _buildSectionHeader('DESCRIPCIÓN', navy, yellow),
                    const SizedBox(height: 16),
                    _buildEliteDescription(widget.ad.description.split('---')[0].trim(), navy, yellow),

                    const SizedBox(height: 40),

                    // INFO CARDS
                    _buildSectionHeader('DATOS DE INTERÉS', navy, yellow),
                    const SizedBox(height: 20),
                    
                    if (widget.ad.businessHours != null)
                      _buildEliteInfoCard(Icons.access_time_filled_rounded, 'HORARIO', widget.ad.businessHours!, navy),
                    
                    if (widget.ad.address != null)
                      _buildEliteInfoCard(Icons.directions_rounded, 'UBICACIÓN', widget.ad.address!, navy, 
                        onTap: () => _launchUrl("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.ad.address!)}", 'maps')),
                    
                    if (widget.ad.priceRange != null)
                      _buildEliteInfoCard(Icons.payments_rounded, 'INVERSIÓN', widget.ad.priceRange!, navy),

                    const SizedBox(height: 40),
                    
                    // SOCIAL LINKS
                    if (widget.ad.facebookUrl != null || widget.ad.instagramUrl != null)
                      _buildEliteSocialSection(navy, yellow),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // STICKY CTA
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isOwner ? _buildUpgradeButton(context, navy, yellow) : _buildWhatsAppButton(navy, yellow),
    );
  }

  Widget _buildSectionHeader(String title, Color navy, Color yellow) {
    return Row(
      children: [
        Container(width: 4, height: 16, decoration: BoxDecoration(color: yellow, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(
          title, 
          style: GoogleFonts.outfit(
            fontSize: 10, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 2, 
            color: navy.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  Widget _buildEliteContactHub(Color navy, Color yellow) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: yellow.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
        image: DecorationImage(
          image: const NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
          opacity: 0.05,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.srcIn),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: yellow, size: 20),
              const SizedBox(width: 8),
              Text(
                'CONTACTO PREMIUM',
                style: GoogleFonts.outfit(color: yellow, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (widget.ad.cellphone != null)
            _buildPremiumContactItem(Icons.phone_android_rounded, 'WhatsApp', widget.ad.cellphone!, yellow, () => _launchUrl('https://wa.me/${widget.ad.cellphone}', 'contact')),
          if (widget.ad.phone != null)
            _buildPremiumContactItem(Icons.phone_in_talk_rounded, 'Teléfono Directo', widget.ad.phone!, yellow, () => _launchUrl('tel:${widget.ad.phone}', 'call')),
          if (widget.ad.facebookUrl != null)
            _buildPremiumContactItem(Icons.facebook_rounded, 'Facebook Oficial', 'Visitar Perfil', yellow, () => _launchUrl(widget.ad.facebookUrl!, 'facebook')),
        ],
      ),
    );
  }

  Widget _buildPremiumContactItem(IconData icon, String label, String value, Color yellow, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: yellow, size: 20),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: yellow.withOpacity(0.5), size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildActionPanel(BuildContext context, Color navy, Color yellow) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           _buildActionItem(Icons.phone_in_talk_rounded, 'Llamar', () {
            if (widget.ad.cellphone != null) _launchUrl('tel:${widget.ad.cellphone}', 'call');
          }),
          _isStartingChat 
            ? SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: navy)))
            : _buildActionItem(Icons.chat_bubble_rounded, 'Chat', () => _startChat(context)),
          _buildActionItem(Icons.public_rounded, 'Web', () {
             if (widget.ad.websiteUrl != null) _launchUrl(widget.ad.websiteUrl!, 'web');
          }),
          _buildActionItem(Icons.share_rounded, 'Compartir', () => _shareAd()),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0E2244), size: 20),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEliteInfoCard(IconData icon, String label, String value, Color navy, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF8F9FB), borderRadius: BorderRadius.circular(15)),
              child: Icon(icon, color: navy, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: navy)),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildEliteSocialSection(Color navy, Color yellow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('SÍGUENOS', navy, yellow),
        const SizedBox(height: 16),
        Row(
          children: [
            if (widget.ad.facebookUrl != null)
              _buildEliteSocialButton(Icons.facebook_rounded, 'Facebook', navy, () => _launchUrl(widget.ad.facebookUrl!, 'facebook')),
            const SizedBox(width: 12),
            if (widget.ad.instagramUrl != null)
              _buildEliteSocialButton(Icons.camera_alt_outlined, 'Instagram', navy, () => _launchUrl(widget.ad.instagramUrl!, 'instagram')),
          ],
        ),
      ],
    );
  }

  Widget _buildEliteSocialButton(IconData icon, String label, Color navy, VoidCallback onTap) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          side: BorderSide(color: navy.withOpacity(0.05)),
        ),
      ),
    );
  }

  Widget _buildUpgradeButton(BuildContext context, Color navy, Color yellow) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: yellow.withOpacity(0.35),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UpgradeAdScreen(ad: widget.ad))),
          style: ElevatedButton.styleFrom(
            backgroundColor: navy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: yellow, size: 22),
              const SizedBox(width: 12),
              Text(
                'DESTACAR ESTE ANUNCIO',
                style: GoogleFonts.outfit(color: yellow, fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton(Color navy, Color yellow) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: yellow.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            final String message = 'Hola, estoy interesado en tu anuncio "${widget.ad.title}" que vi en KLICUS.';
             _launchUrl("https://wa.me/${widget.ad.cellphone ?? '573201234567'}?text=${Uri.encodeComponent(message)}", 'contact');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: yellow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message_rounded, color: navy, size: 22),
              const SizedBox(width: 12),
              Text(
                'CONTACTAR POR WHATSAPP',
                style: GoogleFonts.outfit(color: navy, fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEliteDescription(String text, Color navy, Color yellow) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lines.any((l) => l.trim().length < 35))
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: lines.where((l) => l.trim().length < 35).map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: navy.withOpacity(0.05)),
                  boxShadow: [BoxShadow(color: navy.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: yellow.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.check, color: navy, size: 8),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.trim(),
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: navy.withOpacity(0.8)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        if (lines.any((l) => l.trim().length >= 35)) ...[
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines.where((l) => l.trim().length >= 35).map((para) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  para.trim(),
                  style: GoogleFonts.inter(
                    fontSize: 15, 
                    height: 1.8, 
                    color: navy.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
