import 'package:contact_management/core/model/request/updateContactRequest/UpdateContactRequest.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/deleteContactResponse/DeleteContactResponse.dart';
import 'package:contact_management/core/model/response/updateContactResponse/UpdateContactResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/home_screen.dart';
import 'package:contact_management/theme/app_style.dart';
import 'package:contact_management/theme/color_constant.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';

class ManageContactScreen extends StatefulWidget {
  const ManageContactScreen({super.key, required this.contactResponse});

  final ContactResponse contactResponse;

  @override
  State<ManageContactScreen> createState() => _ManageContactScreenState();
}

class _ManageContactScreenState extends State<ManageContactScreen> {
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
  Future<UpdateContactResponse>? updateContactResponse;
  List<UpdateContactResponse>? update;
  Future<DeleteContactResponse>? deleteContactResponse;

  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper().getUserInformation().then((value) {
      setState(() {
        updateContactResponse = service.updateContacts(
            UpdateContactRequest(
                name: nameController.text.toString().trim(),
                email: emailController.text.toString().trim(),
                phone: passwordController.text.toString().trim()),
            {"Bearer ${value.accessToken}"},
            widget.contactResponse.id!);
        print(
            "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${widget.contactResponse.id}");
        print("************************${updateContactResponse}");
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

    final createContact = Container(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });
            SharedPreferenceHelper().getUserInformation().then((value) {
              var request = UpdateContactRequest(
                  name: nameController.text.toString().trim(),
                  email: emailController.text.toString().trim(),
                  phone: passwordController.text.toString().trim());
              service
                  .updateContacts(request, "Bearer ${value.accessToken}",
                      widget.contactResponse.id ?? 0)
                  .then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              contactResponse: widget.contactResponse,
                            )));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Contact Updated successfully")));
                print("does it reach here?");
              }).onError((error, stackTrace) {
                showMessage("Contact not updated");
                setState(() {
                  isLoading = false;
                });
              });
            });
          }
        },
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          backgroundColor: submits ? ColorConstant.teal800 : Colors.grey,
          disabledBackgroundColor: ColorConstant.gray600,
          minimumSize: Size(360, 55),
        ),
        child: Text(
          "Edit Contact",
          style: AppStyle.txtInterMediums18.copyWith(
            letterSpacing: 0.72,
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Center(
            child: Text(
              'View Contact',
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
          automaticallyImplyLeading: true,
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
