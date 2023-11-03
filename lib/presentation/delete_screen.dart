import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/deleteGroup/DeleteGroupResponse.dart';
import 'package:contact_management/core/model/response/groupResponse/GroupResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/home_screen.dart';
import 'package:contact_management/theme/app_style.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen(
      {super.key,
      required this.contactResponse,
      required this.selectedContacts,
      required this.groupResponse});

  final ContactResponse contactResponse;
  final List<ContactResponse> selectedContacts;

  final GroupResponse groupResponse;

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  NetworkService service = NetworkService();
  Future<DeleteGroupResponse>? deleteGroupResponse;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper().getUserInformation().then((value) {
      setState(() {
        deleteGroupResponse = service.deleteGroup(
            "Bearer ${value.accessToken}", widget.groupResponse.id!);
        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${widget.groupResponse.id}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Center(
          child: Text(
            'View Group',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtInterSemiBold24.copyWith(
              letterSpacing: getHorizontalSize(0.50),
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: isLoading
                ? null
                : () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete Group"),
                          content: Text(
                              "Are you sure you want to delete this group?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Delete"),
                              onPressed: () async {
                                Navigator.of(context).pop(); // Close dialog
                                setState(() {
                                  isLoading = true;
                                });
                                SharedPreferenceHelper()
                                    .getUserInformation()
                                    .then((value) {
                                  service
                                      .deleteGroup(
                                    "Bearer ${value.accessToken}",
                                    widget.groupResponse.id ?? 0,
                                  )
                                      .then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Group Deleted successfully"),
                                      ),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          contactResponse:
                                              widget.contactResponse,
                                          groupResponse: widget.groupResponse,
                                          selectedContacts:
                                              widget.selectedContacts,
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }).onError((error, stackTrace) {
                                    showMessage("Group not deleted");
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
          ),
        ],
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

  Future<void> _pullRefresh() async {
    SharedPreferenceHelper().getUserInformation().then((value) {
      var service = NetworkService();
      setState(() {
        deleteGroupResponse = service.deleteGroup(
            "Bearer ${value.accessToken}", widget.groupResponse.id!);
      });
    });
  }
}
