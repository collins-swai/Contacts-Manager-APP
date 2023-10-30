import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/presentation/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  var widget = ContactResponse();
  runApp(MyApp(
    contactResponse: widget,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.contactResponse});

  final ContactResponse contactResponse;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        contactResponse: widget.contactResponse,
      ),
    );
  }
}
