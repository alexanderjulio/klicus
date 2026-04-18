import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'BIENVENIDO A\nKLICUS ELITE',
      description: 'La red más exclusiva de socios para conectar tus servicios con el mercado premium.',
      color: const Color(0xFFE2E000),
    ),
    OnboardingData(
      title: 'NEGOCIOS CON\nCONFIANZA',
      description: 'Blindamos cada interacción y pago para que tu única preocupación sea crecer.',
      color: const Color(0xFFE2E000),
    ),
    OnboardingData(
      title: 'GESTIÓN EN TU\nBOLSILLO',
      description: 'Publica, edita y analiza el rendimiento de tus pautas desde cualquier lugar.',
      color: const Color(0xFFE2E000),
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index]);
            },
          ),
          
          // Navigation & Indicators
          Positioned(
            bottom: 60,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicators
                Row(
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 4,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? const Color(0xFF0E2244) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),

                // Button
                GestureDetector(
                  onTap: () {
                    if (_currentPage == _pages.length - 1) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutQuint,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E000),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'COMENZAR' : 'SIGUIENTE',
                      style: const TextStyle(
                        color: Color(0xFF0E2244),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final Color color;

  OnboardingData({required this.title, required this.description, required this.color});
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          // Clean Logo Placeholder or Brand mark
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0E2244),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              height: 1.0,
              color: data.color,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.description,
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
