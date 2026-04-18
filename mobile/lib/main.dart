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
import 'features/auth/auth_provider.dart';
import 'features/notifications/notification_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuth()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()..startPolling()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        Provider(create: (_) => ApiService()),
        ProxyProvider<ApiService, AnalyticsService>(
          update: (_, api, __) => AnalyticsService(api),
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
        scaffoldBackgroundColor: const Color(0xFFF4F7FA), // Premium Minimalist Background
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF4F7FA), // Sync AppBar Background
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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
        '/home': (context) => const MainNavigation(),
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
