import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/onboarding_screen/data/repo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_OnboardPage> pages = [
    _OnboardPage(
      title: text.onboarding1Title,
      description: text.onBoarding1Subtitle,
      image: ImageConstants.onboarding1,
      buttonText: text.next,
    ),
    _OnboardPage(
      title: text.onboarding2Title,
      description: text.onBoarding2Subtitle,
      image: ImageConstants.onboarding2,
      buttonText: text.next,
    ),
    _OnboardPage(
      title: text.onboarding3Title,
      description: text.onBoarding3Subtitle,
      image: ImageConstants.onboarding3,
      buttonText: text.letsGo,
    ),
  ];

  void _onNextPressed() {
    if (_currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
       WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
      OnboardingRepo repo = OnboardingRepo();
      repo.updateOnboarding();
       
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 28.0,
                      top: 20.0,
                      right: 28,
                      bottom: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          page.title,
                          style: AppTextStyles.textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          page.description,
                          style: AppTextStyles.textTheme.bodySmall,
                        ),
                        Expanded(
                          child: Image.asset(page.image, fit: BoxFit.contain),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildIndicator(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  pages[_currentIndex].buttonText,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.grey : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _OnboardPage {
  final String title;
  final String description;
  final String image;
  final String buttonText;

  _OnboardPage({
    required this.title,
    required this.description,
    required this.image,
    required this.buttonText,
  });
}
