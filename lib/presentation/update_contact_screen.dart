import 'package:contact_management/core/model/request/updateContactRequest/UpdateContactRequest.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/deleteContactResponse/DeleteContactResponse.dart';
import 'package:contact_management/core/model/response/groupResponse/GroupResponse.dart';
import 'package:contact_management/core/model/response/updateContactResponse/UpdateContactResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/add_group_screen.dart';
import 'package:contact_management/presentation/home_screen.dart';
import 'package:contact_management/presentation/view_group.dart';
import 'package:contact_management/theme/app_style.dart';
import 'package:contact_management/theme/color_constant.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';

class UpdateContactScreen extends StatefulWidget {
  const UpdateContactScreen(
      {super.key,
      required this.contactResponse,
      required this.groupResponse,
      required this.selectedContacts});

  final ContactResponse contactResponse;
  final List<ContactResponse> selectedContacts;

  final GroupResponse groupResponse;

  @override
  State<UpdateContactScreen> createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  NetworkService service = NetworkService();
  Future<List<GroupResponse>>? groupResponse;
  List<GroupResponse>? response;

  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper().getUserInformation().then((value) {
      setState(() {
        groupResponse = service.getGroups("Bearer ${value.accessToken}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('View Group')),
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          contactResponse: widget.contactResponse,
                          groupResponse: widget.groupResponse, selectedContacts: widget.selectedContacts,
                        )));
          },
          child: Icon(
            Icons.arrow_back_sharp, // add custom icons also
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupScreen(
                                contactResponse: widget.contactResponse,
                                groupResponse: widget.groupResponse, selectedContacts: widget.selectedContacts,
                              )));
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: FutureBuilder<List<GroupResponse>>(
          future: groupResponse,
          builder: (context, snapshot) {
            print("data reaches here for${groupResponse}");
            if (snapshot.hasData) {
              child:
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  print("data reaches here ${snapshot.data?[index].id}");
                  return Padding(
                    padding: getPadding(top: 5),
                    child: Card(
                      child: ListTile(
                        title: Text('${snapshot.data?[index].name}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('${widget.selectedContacts[index].name}')
                          ],
                        ),
                        leading: Icon(Icons.group),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('View Group'),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                        // You can customize the leading icon here
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewGroupScreen(
                                        contactResponse: widget.contactResponse,
                                        groupResponse: snapshot.data![index],
                                        selectedContacts:
                                            widget.selectedContacts,
                                      )));
                          print("%%%%%%%%%%%%%%%%%%%%${widget.groupResponse}");

                          print(
                              "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${widget.contactResponse.id}");
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(
              child: const SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
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

  Future<void> _pullRefresh() async {
    SharedPreferenceHelper().getUserInformation().then((value) {
      var service = NetworkService();
      setState(() {
        groupResponse = service.getGroups("Bearer ${value.accessToken}");
      });
    });
  }
}
