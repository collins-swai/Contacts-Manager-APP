import 'package:contact_management/core/model/request/createGroupRequest/CreateGroupRequest.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/home_screen.dart';
import 'package:contact_management/theme/app_style.dart';
import 'package:contact_management/theme/color_constant.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key, required this.contactResponse});

  final ContactResponse contactResponse;

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

        createGroupRequest = service.newGroup(
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
          if (_formKey.currentState!.validate()) {
            setState(() {
              isLoading = true;
            });
            SharedPreferenceHelper().getUserInformation().then((value) {
              var request = CreateGroupRequest(
                  name: nameController.text.toString().trim());
              service
                  .newGroup(request, "Bearer ${value.accessToken}")
                  .then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              contactResponse: widget.contactResponse,
                            )));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Group Created successfully")));
              }).onError((error, stackTrace) {
                showMessage("Group not created");
                setState(() {
                  isLoading = false;
                });
              });
            });
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
                          )));
            },
            child: Icon(
              Icons.arrow_back_sharp, // add custom icons also
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
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
                            print(
                                "data reaches here ${snapshot.data?[index].id}");
                            return Padding(
                              padding: getPadding(left: 9, right: 9),
                              child: Card(
                                child: CheckboxListTile(
                                  title: Text('${snapshot.data?[index].name}'),
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
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
                child:
                    isLoading ? const CircularProgressIndicator() : createGroup,
              )
            ],
          ),
        ),
        // body: Padding(
        //   padding: EdgeInsets.all(16.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Group Name:',
        //         style: TextStyle(fontSize: 18),
        //       ),
        //       TextFormField(
        //         controller: groupNameController,
        //         decoration: InputDecoration(
        //           hintText: 'Enter group name',
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       Text(
        //         'Select Contacts:',
        //         style: TextStyle(fontSize: 18),
        //       ),
        //       Expanded(
        //         child: ListView.builder(
        //           itemCount: contacts.length,
        //           itemBuilder: (context, index) {
        //             return CheckboxListTile(
        //               title: Text(contacts[index].name),
        //               value: contacts[index].isSelected,
        //               onChanged: (value) {
        //                 setState(() {
        //                   contacts[index].isSelected = value!;
        //                 });
        //               },
        //             );
        //           },
        //         ),
        //       ),
        //       SizedBox(height: 20),
        //       Center(
        //         child: ElevatedButton(
        //           onPressed: () {
        //             // Perform action on button press, e.g., create the group
        //             String groupName = groupNameController.text;
        //             List<Contact> selectedContacts =
        //                 contacts.where((contact) => contact.isSelected).toList();
        //             // Perform action with group name and selected contacts
        //             // For example: Create the group with the given name and contacts
        //             print('Group Name: $groupName');
        //             print(
        //                 'Selected Contacts: ${selectedContacts.map((contact) => contact.name).toList()}');
        //           },
        //           child: Text('Create Group'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
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
