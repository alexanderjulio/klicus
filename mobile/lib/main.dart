import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/nav_provider.dart';
import 'core/api_service.dart';
import 'core/services/push_service.dart';
import 'core/services/analytics_service.dart';
import 'core/services/connectivity_provider.dart';
import 'core/services/favorites_provider.dart';
import 'core/services/stats_provider.dart';
import 'core/repositories/ad_repository.dart';
import 'core/repositories/user_repository.dart';
import 'core/repositories/chat_repository.dart';
import 'core/repositories/admin_repository.dart';
import 'features/auth/auth_provider.dart';
import 'features/profile/profile_provider.dart';
import 'features/notifications/notification_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/splash/splash_screen.dart';
import 'core/widgets/main_navigation.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Only on Mobile, requires config on Web)
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp();
      await PushNotificationService.initialize(navigatorKey);
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
    }
  }

  // Build shared singletons first so dependent providers receive the same instance
  final apiService = ApiService();
  final statsProvider = StatsProvider(apiService);
  final profileProvider = ProfileProvider(apiService);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider<StatsProvider>.value(value: statsProvider),
        ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            apiService: apiService,
            statsProvider: statsProvider,
            profileProvider: profileProvider,
          )..checkAuth(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()..startPolling()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()..load()),
        ProxyProvider<ApiService, AnalyticsService>(
          update: (_, api, __) => AnalyticsService(api),
        ),
        ProxyProvider<ApiService, AdRepository>(
          update: (_, api, __) => AdRepository(api),
        ),
        ProxyProvider<ApiService, UserRepository>(
          update: (_, api, __) => UserRepository(api),
        ),
        ProxyProvider<ApiService, ChatRepository>(
          update: (_, api, __) => ChatRepository(api),
        ),
        ProxyProvider<ApiService, AdminRepository>(
          update: (_, api, __) => AdminRepository(api),
        ),
      ],
      child: const KlicusApp(),
    ),
  );

  // Initialize Analytics in background
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AnalyticsService(ApiService()).init();
  });
}

class KlicusApp extends StatelessWidget {
  const KlicusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      navigatorKey: navigatorKey,
      title: 'KLICUS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Dual Typography System: Inter for body, Outfit for headings
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.light().textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE2E000),
          primary: const Color(0xFFE2E000),
          secondary: const Color(0xFF0E2244),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FB), // Premium Minimalist Background
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF8F9FB), // Sync AppBar Background
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF0E2244)),
          titleTextStyle: GoogleFonts.outfit(
            color: const Color(0xFF0E2244),
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const MainNavigation(),
        '/home': (context) => const MainNavigation(),
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
