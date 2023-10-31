import 'package:contact_management/core/model/request/createGroupRequest/CreateGroupRequest.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/groupResponse/GroupResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/home_screen.dart';
import 'package:contact_management/theme/app_style.dart';
import 'package:contact_management/theme/color_constant.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen(
      {super.key,
      required this.contactResponse,
      required this.groupResponse,
      required this.selectedContacts});

  final ContactResponse contactResponse;

  final List<ContactResponse> selectedContacts;

  final GroupResponse groupResponse;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  NetworkService service = NetworkService();
  final FocusNode _focusNode = FocusNode();
  bool isSelected = false;
  bool _isChecked = false;
  bool submits = false;
  bool isLoading = false;
  Set<int> selectedContactIds = Set<int>();

  Future<List<ContactResponse>>? contactResponse;
  List<ContactResponse>? response;
  Future<CreateGroupRequest>? createGroupRequest;
  List<CreateGroupRequest>? createGroup;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pullRefresh();
      SharedPreferenceHelper().getUserInformation().then((value) {
        contactResponse = service.getContacts("Bearer ${value.accessToken}");

        createGroupRequest = service.createGroupResponses(
            CreateGroupRequest(name: nameController.text.toString().trim()),
            "Bearer ${value.accessToken}") as Future<CreateGroupRequest>?;
        print("@@@@@@@@@@@@@12345${value.accessToken}");
      });
      Future.delayed(const Duration(seconds: 2));
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

    final createGroup = Material(
      child: MaterialButton(
        color: ColorConstant.teal800,
        shape: StadiumBorder(),
        minWidth: 350,
        onPressed: () async {
          print("Button pressed");
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });

            try {
              final value = await SharedPreferenceHelper().getUserInformation();
              final request = CreateGroupRequest(
                name: nameController.text.toString().trim(),
              );

              final createdGroup = await service.createGroupResponses(
                request,
                "Bearer ${value.accessToken}",
              );

              setState(() {
                isLoading = false;
              });

              if (createdGroup != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Group Created successfully")),
                );

                // Navigate to the desired screen upon successful creation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      contactResponse: widget.contactResponse,
                      groupResponse: widget.groupResponse,
                      selectedContacts: widget.selectedContacts,
                    ),
                  ),
                );
              } else {
                showMessage("Group not created");
              }
            } catch (error) {
              setState(() {
                isLoading = false;
              });
              showMessage("An error occurred: $error");
            }
          }
        },
        child: Text(
          "Add New Group",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create New Group'),
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            contactResponse: widget.contactResponse,
                            groupResponse: widget.groupResponse,
                            selectedContacts: widget.selectedContacts,
                          )));
            },
            child: Icon(
              Icons.arrow_back_sharp, // add custom icons also
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    child: FutureBuilder<List<ContactResponse>>(
                      future: contactResponse,
                      builder: (context, snapshot) {
                        print("data reaches here for${contactResponse}");
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final contactId = snapshot.data?[index].id ?? 0;
                              final isSelected =
                                  selectedContactIds.contains(contactId);
                              print(
                                  "data reaches here ${snapshot.data?[index].id}");
                              return Padding(
                                padding: getPadding(left: 9, right: 9),
                                child: Card(
                                  child: CheckboxListTile(
                                    title:
                                        Text('${snapshot.data?[index].name}'),
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          selectedContactIds.add(contactId);
                                        } else {
                                          selectedContactIds.remove(contactId);
                                        }
                                      });
                                    },
                                  ),
                                  // child: ListTile(
                                  //   // title: Text('${snapshot.data?[index].name}'),
                                  //   // subtitle: Column(
                                  //   //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   //   children: [
                                  //   //     Text('Email: ${snapshot.data?[index].email}'),
                                  //   //     Text('Phone: ${snapshot.data?[index].phone}'),
                                  //   //   ],
                                  //   // ),
                                  // ),
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
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : createGroup,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    SharedPreferenceHelper().getUserInformation().then((value) {
      var service = NetworkService();
      setState(() {
        contactResponse = service.getContacts("Bearer ${value.accessToken}");
      });
    });
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
