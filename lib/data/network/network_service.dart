import 'dart:convert';
import 'dart:developer';
import 'package:contact_management/core/model/request/createContactRequest/CreateContactRequest.dart';
import 'package:contact_management/core/model/request/createGroupRequest/CreateGroupRequest.dart';
import 'package:contact_management/core/model/request/loginRequest/LoginRequest.dart';
import 'package:contact_management/core/model/request/register/RegisterRequest.dart';
import 'package:contact_management/core/model/request/updateContactRequest/UpdateContactRequest.dart';
import 'package:contact_management/core/model/response/contactResponse/ContactResponse.dart';
import 'package:contact_management/core/model/response/createContactRespone/CreateContactResponse.dart';
import 'package:contact_management/core/model/response/createGroupResponse/CreateGroupResponse.dart';
import 'package:contact_management/core/model/response/deleteContactResponse/DeleteContactResponse.dart';
import 'package:contact_management/core/model/response/loginResponse/LoginResponse.dart';
import 'package:contact_management/core/model/response/updateContactResponse/UpdateContactResponse.dart';
import 'package:http/http.dart' as http;
import 'package:contact_management/core/model/response/RegisterResponse/RegisterResponse.dart';

class NetworkService {
  static final BASE_URL = "https://6d41-102-135-170-132.ngrok-free.app/api/";

  static final register = BASE_URL + "register";
  static final login = BASE_URL + "login";
  static final contacts = BASE_URL + "contacts";
  static final createContact = BASE_URL + "contacts";
  static final updateContact = BASE_URL + "contacts/";
  static final deleteContact = BASE_URL + "contacts/";
  static final newGroups = BASE_URL + "groups";

  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    var uri = Uri.parse(register);
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    try {
      var response =
          await http.post(uri, body: request.toJson(), headers: requestHeaders);
      print("!!!!!!!!!!!!!!!!!!!${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("################${response.statusCode}");
        return RegisterResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  Future<dynamic> loginUser(LoginRequest request) async {
    var uri = Uri.parse(login);
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };
    try {
      var response =
          await http.post(uri, body: request.toJson(), headers: requestHeaders);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        print("@@@@@@@@@@@@@@${response.statusCode}");
        print("@@@@@@@@@@@@@@${response.body}");
        // return LoginErrorResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return throw Exception(e);
    }
  }

  Future<List<ContactResponse>> getContacts(String token) async {
    var uri = Uri.parse(contacts);
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token
    };
    try {
      var response = await http.get(uri, headers: requestHeaders);
      log(response.body.toString());
      print(response.body);
      print(response.request);
      print(response.headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body) as List<dynamic>;
        var res = data.map((e) => ContactResponse.fromJson(e)).toList();
        log("-------------------------------------------------------${res}");
        return res;
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      log(e.toString());
      throw Exception("Error $e");
    }
  }

  Future<CreateContactResponse> createContactsRequests(
      CreateContactRequest createContactRequest, String token) async {
    var uri = Uri.parse(contacts);
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token
    };
    print(">>>>>>>>>>>>>>>>>>>>>>${createContactRequest.toJson()}");
    var response = await http.post(uri,
        body: json.encode(createContactRequest), headers: requestHeaders);
    print("++++++++++++++++++++++${json.decode(response.body)}");
    print(
        "=====================================>${CreateContactRequest.fromJson(jsonDecode(response.body))}");
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateContactResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      log(e.toString());
      throw Exception("Error $e");
    }
  }

  Future<UpdateContactResponse> updateContacts(
      UpdateContactRequest updateContactRequest, token, int id) async {
    var uri = Uri.parse(contacts + "/${id}");
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token
    };
    try {
      var response = await http.put(uri, headers: requestHeaders);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${response.body}");
      print("*************************************${response.statusCode}");
      print(
          "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${UpdateContactResponse.fromJson(jsonDecode(response.body))}");
      log(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateContactResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      log(e.toString());
      throw Exception("Error $e");
    }
  }

  Future<DeleteContactResponse> deleteContacts(String token, int id) async {
    var uri = Uri.parse(contacts + "/${id}");
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token
    };
    try {
      var response = await http.delete(uri, headers: requestHeaders);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${response.body}");
      print("*************************************${response.body}");
      print(
          "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${DeleteContactResponse.fromJson(jsonDecode(response.body))}");
      log(response.body.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeleteContactResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      log(e.toString());
      throw Exception("Error $e");
    }
  }

  Future<CreateGroupResponse> newGroup(
      CreateGroupRequest createGroupRequest, String token) async {
    var uri = Uri.parse(newGroups);
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token
    };
    print(">>>>>>>>>>>>>>>>>>>>>>${createGroupRequest.toJson()}");
    var response = await http.post(uri,
        body: json.encode(createGroupRequest), headers: requestHeaders);
    print("++++++++++++++++++++++${json.decode(response.body)}");
    print(
        "=====================================>${CreateContactRequest.fromJson(jsonDecode(response.body))}");
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateGroupResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Error ${response.body}");
      }
    } catch (e) {
      log(e.toString());
      throw Exception("Error $e");
    }
  }
}
