import 'package:contact_management/core/model/request/createContactRequest/CreateContactRequest.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/createContactRespone/CreateContactResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/home_screen.dart';
import 'package:contact_management/theme/app_style.dart';
import 'package:contact_management/theme/color_constant.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key, required this.contactResponse});

  final ContactResponse contactResponse;

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  NetworkService service = NetworkService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool _isHidden = true;
  bool submit = false;
  bool submits = false;
  String _errorMessage = '';
  Future<CreateContactResponse>? createContactResponse;
  List<CreateContactResponse>? register;

  @override
  void initState() {
    super.initState();
    setState(() {
      SharedPreferenceHelper().getUserInformation().then((value) {
        createContactResponse = service.createContactsRequests(
            CreateContactRequest(
                name: nameController.text,
                email: emailController.text,
                phone: passwordController.text),
            "Bearer ${value.accessToken}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: nameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Contact Name';
        }
        return null;
      },
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.fromLTRB(14.0, 1.0, 4.0, 2.0),
          labelText: "Name",
          labelStyle: AppStyle.txtInterMedium12.copyWith(
            letterSpacing: 0.50,
            height: 1.00,
          ),
          fillColor: ColorConstant.gray100),
    );

    final emailField = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.fromLTRB(14.0, 1.0, 4.0, 2.0),
          labelText: "Contact Email",
          labelStyle: AppStyle.txtInterMedium12.copyWith(
            letterSpacing: 0.50,
            height: 1.00,
          ),
          fillColor: ColorConstant.gray100),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.fromLTRB(14.0, 1.0, 4.0, 2.0),
        labelText: "Contact Phone Number",
        labelStyle: AppStyle.txtInterMedium12.copyWith(
          letterSpacing: 0.50,
          height: 1.00,
        ),
      ),
    );

    final createContact = Material(
      child: MaterialButton(
        color: ColorConstant.teal800,
        shape: StadiumBorder(),
        minWidth: 350,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });
            SharedPreferenceHelper().getUserInformation().then((value) {
              var request = CreateContactRequest(
                  name: nameController.text.toString().trim(),
                  email: emailController.text.toString().trim(),
                  phone: passwordController.text.toString().trim());
              service
                  .createContactsRequests(
                      request, "Bearer ${value.accessToken}")
                  .then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              contactResponse: widget.contactResponse,
                            )));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Contact Created successfully")));
              }).onError((error, stackTrace) {
                showMessage("Contact not created");
                setState(() {
                  isLoading = false;
                });
              });
            });
          }
        },
        child: Text(
          "Add New Contact",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Center(
            child: Text(
              'New Contact',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtInterSemiBold24.copyWith(
                letterSpacing: getHorizontalSize(
                  0.50,
                ),
              ),
            ),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: getPadding(top: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: getVerticalSize(74.00),
                      width: getHorizontalSize(396.00),
                      margin: getMargin(left: 16, right: 16, bottom: 4),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: getVerticalSize(
                                74.00,
                              ),
                              width: getHorizontalSize(
                                396.00,
                              ),
                              margin: getMargin(
                                top: 10,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: nameField,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(top: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: getVerticalSize(74.00),
                      width: getHorizontalSize(396.00),
                      margin: getMargin(left: 16, right: 16, bottom: 4),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: getVerticalSize(
                                74.00,
                              ),
                              width: getHorizontalSize(
                                396.00,
                              ),
                              margin: getMargin(
                                top: 10,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: emailField,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(top: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: getVerticalSize(74.00),
                      width: getHorizontalSize(396.00),
                      margin: getMargin(left: 16, right: 16, bottom: 4),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: getVerticalSize(
                                74.00,
                              ),
                              width: getHorizontalSize(
                                396.00,
                              ),
                              margin: getMargin(
                                top: 10,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: passwordField,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(top: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: getPadding(bottom: 2),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : createContact,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(top: 15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: getVerticalSize(74.00),
                      width: getHorizontalSize(396.00),
                      margin: getMargin(left: 16, right: 16, bottom: 4),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: getVerticalSize(
                                74.00,
                              ),
                              width: getHorizontalSize(
                                396.00,
                              ),
                              margin: getMargin(
                                top: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
