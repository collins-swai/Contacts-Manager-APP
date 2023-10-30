import 'dart:convert';

class RegisterRequest {
  String? name;
  String? email;
  String? password;

  RegisterRequest({this.name, this.email, this.password});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }
}

