import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/presentation/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.contactResponse});

  final ContactResponse contactResponse;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/uzapoint.png'),
        duration: 5000,
        nextScreen: RegisterScreen(
          contactResponse: widget.contactResponse,
        ),
        splashTransition: SplashTransition.slideTransition,
        pageTransitionType: PageTransitionType.leftToRightWithFade,
      ),
    );
  }
}
