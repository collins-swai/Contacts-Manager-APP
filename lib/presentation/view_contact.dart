import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/loginResponse/LoginResponse.dart';
import 'package:contact_management/data/network/network_service.dart';
import 'package:contact_management/data/sharedPreference/shared_preference_helper.dart';
import 'package:contact_management/presentation/manage_contact.dart';
import 'package:contact_management/presentation/update_contact_screen.dart';
import 'package:contact_management/theme/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ViewContactScreen extends StatefulWidget {
  const ViewContactScreen({super.key, required this.contactResponse});

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
  final ContactResponse contactResponse;
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  NetworkService service = NetworkService();
  final FocusNode _focusNode = FocusNode();

  Future<List<ContactResponse>>? contactResponse;
  List<ContactResponse>? response;

  @override
  void initState() {
    super.initState();
    setState(() {
      _pullRefresh();
      SharedPreferenceHelper().getUserInformation().then((value) {
        contactResponse = service.getContacts("Bearer ${value.accessToken}");
        print("@@@@@@@@@@@@@12345${value.accessToken}");
        print("WWWWWWWWWWW${contactResponse}");
        print("******************${widget.contactResponse.id}");
      });
      Future.delayed(const Duration(seconds: 2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contact List'),
        ),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: FutureBuilder<List<ContactResponse>>(
            future: contactResponse,
            builder: (context, snapshot) {
              print("data reaches here for${contactResponse}");
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
                              Text('Email: ${snapshot.data?[index].email}'),
                              Text('Phone: ${snapshot.data?[index].phone}'),
                            ],
                          ),
                          leading: Icon(Icons.person),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('View More'),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          ),
                          // You can customize the leading icon here
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManageContactScreen(
                                          contactResponse: snapshot.data![index],
                                        )));

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
}
