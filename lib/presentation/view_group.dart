import 'package:contact_management/core/model/request/groupUpdateRequest/GroupUpdateRequest.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/deleteGroup/DeleteGroupResponse.dart';
import 'package:contact_management/core/model/response/groupResponse/GroupResponse.dart';
import 'package:contact_management/core/model/response/groupUpdateResponse/GroupUpdateResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/home_screen.dart';
import 'package:contact_management/theme/app_style.dart';
import 'package:contact_management/theme/color_constant.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';

class ViewGroupScreen extends StatefulWidget {
  const ViewGroupScreen(
      {super.key,
      required this.contactResponse,
      required this.groupResponse,
      required this.selectedContacts});

  final ContactResponse contactResponse;
  final GroupResponse groupResponse;
  final List<ContactResponse> selectedContacts;

  @override
  State<ViewGroupScreen> createState() => _ViewGroupScreenState();
}

class _ViewGroupScreenState extends State<ViewGroupScreen> {
  NetworkService service = NetworkService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  bool submits = false;
  Future<GroupUpdateResponse>? groupUpdateResponse;
  List<GroupUpdateResponse>? update;
  Future<DeleteGroupResponse>? deleteGroupResponse;

  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper().getUserInformation().then((value) {
      setState(() {
        groupUpdateResponse = service.groupUpdateRequests(
            GroupUpdateRequest(name: nameController.text.toString().trim()),
            {"Bearer ${value.accessToken}"},
            widget.groupResponse.id!);
        // deleteGroupResponse = service.deleteGroup(
        //     "Bearer ${value.accessToken}", widget.groupResponse.id!);
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${widget.groupResponse.id}");
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
          return 'Please enter your Group Name';
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
          labelText: "Group Name",
          labelStyle: AppStyle.txtInterMedium12.copyWith(
            letterSpacing: 0.50,
            height: 1.00,
          ),
          fillColor: ColorConstant.gray100),
    );

    final updateGroup = Container(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });
            SharedPreferenceHelper().getUserInformation().then((value) {
              var request = GroupUpdateRequest(
                name: nameController.text.toString().trim(),
              );
              service
                  .groupUpdateRequests(request, "Bearer ${value.accessToken}",
                      widget.groupResponse.id ?? 0)
                  .then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              contactResponse: widget.contactResponse,
                              groupResponse: widget.groupResponse,
                              selectedContacts: widget.selectedContacts,
                            )));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Group Updated successfully")));
                print("does it reach here?");
              }).onError((error, stackTrace) {
                showMessage("Group not updated");
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
          "Edit Group",
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
              'View Group',
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
          actions: [
            // IconButton(
            //     icon: Icon(Icons.delete),
            //     onPressed: isLoading
            //         ? null
            //         : () async {
            //             setState(() {
            //               isLoading = true;
            //             });
            //             SharedPreferenceHelper()
            //                 .getUserInformation()
            //                 .then((value) {
            //               service
            //                   .deleteGroup("Bearer ${value.accessToken}",
            //                       widget.groupResponse.id ?? 0)
            //                   .then((value) {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => HomeScreen(
            //                               contactResponse:
            //                                   widget.contactResponse,
            //                               groupResponse: widget.groupResponse,
            //                               selectedContacts:
            //                                   widget.selectedContacts,
            //                             )));
            //                 ScaffoldMessenger.of(context).showSnackBar(
            //                     const SnackBar(
            //                         content:
            //                             Text("Group Deleted successfully")));
            //                 print("does it reach here?");
            //               }).onError((error, stackTrace) {
            //                 showMessage("Contact not deleted");
            //                 setState(() {
            //                   isLoading = false;
            //                 });
            //               });
            //             });
            //           })
          ],
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: getPadding(bottom: 2),
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : updateGroup,
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
