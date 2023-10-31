import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/groupResponse/GroupResponse.dart';
import 'package:contact_management/presentation/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  var widget = ContactResponse();
  var widgets = GroupResponse();
  List<ContactResponse> selectedContacts = [];
  runApp(MyApp(
    contactResponse: widget,
    groupResponse: widgets, selectedContacts: selectedContacts,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key, required this.contactResponse, required this.groupResponse, required this.selectedContacts});

  final ContactResponse contactResponse;

  final GroupResponse groupResponse;

  final List<ContactResponse> selectedContacts;
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
        groupResponse: widget.groupResponse, selectedContacts: widget.selectedContacts,
      ),
    );
  }
}
