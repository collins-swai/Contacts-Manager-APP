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

class UpdateContactScreen extends StatefulWidget {
  const UpdateContactScreen({super.key, required this.contactResponse});

  final ContactResponse contactResponse;

  @override
  State<UpdateContactScreen> createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
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
        deleteContactResponse = service.deleteContacts(
            "Bearer ${value.accessToken}", widget.contactResponse.id!);
        print(
            "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${widget.contactResponse.id}");
        print("************************${updateContactResponse}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deleteContact = Material(
      child: MaterialButton(
        color: ColorConstant.redA700,
        shape: StadiumBorder(),
        minWidth: 350,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          SharedPreferenceHelper().getUserInformation().then((value) {
            service
                .deleteContacts("Bearer ${value.accessToken}",
                    widget.contactResponse.id ?? 0)
                .then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            contactResponse: widget.contactResponse,
                          )));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Contact Deleted successfully")));
              print("does it reach here?");
            }).onError((error, stackTrace) {
              showMessage("Contact not deleted");
              setState(() {
                isLoading = false;
              });
            });
          });
        },
        child: Text(
          "Delete Contact",
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
              'Delete Contact',
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: getPadding(bottom: 2),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : deleteContact,
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
