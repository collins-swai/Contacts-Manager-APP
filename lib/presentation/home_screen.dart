import 'dart:io';

import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/groupResponse/GroupResponse.dart';
import 'package:contact_management/presentation/add_contact.dart';
import 'package:contact_management/presentation/delete_group_screen.dart';
import 'package:contact_management/presentation/manage_contact.dart';
import 'package:contact_management/presentation/view_contact.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'update_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,
    required this.contactResponse,
    required this.groupResponse,
    required this.selectedContacts});

  final GroupResponse groupResponse;

  final ContactResponse contactResponse;

  final List<ContactResponse> selectedContacts;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      ViewContactScreen(
        contactResponse: widget.contactResponse,
        groupResponse: widget.groupResponse,
        selectedContacts: widget.selectedContacts,
      ),
      UpdateContactScreen(
        contactResponse: widget.contactResponse,
        groupResponse: widget.groupResponse,
        selectedContacts: widget.selectedContacts,
      ),
      AddContactScreen(
        contactResponse: widget.contactResponse,
        groupResponse: widget.groupResponse,
        selectedContacts: widget.selectedContacts,
      ),
      DeleteGroupScreen(contactResponse: widget.contactResponse,
          groupResponse: widget.groupResponse,
          selectedContacts: widget.selectedContacts)
    ];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 1,
                activeColor: Colors.black,
                iconSize: 18,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: const [
                  GButton(
                    icon: LineIcons.fileContract,
                    text: 'View Contact',
                  ),
                  GButton(
                    icon: LineIcons.addressBook,
                    text: 'Add Group',
                  ),
                  GButton(
                    icon: LineIcons.addToShoppingCart,
                    text: 'Create Contact',
                  ),
                  GButton(
                    icon: LineIcons.removeUser,
                    text: 'Delete Group',
                  )
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        body: _widgetOptions?.elementAt(_selectedIndex),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    _onBackPressed();
    return true;
  }

  Object _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Do you want to exit the App'),
          actions: <Widget>[
            MaterialButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(false); //Will not exit the App
              },
            ),
            MaterialButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                exit(0);
              },
            )
          ],
        );
      },
    );
  }

  void _onTap(int index) {
    _selectedIndex = index;
    setState(() {});
  }
}
