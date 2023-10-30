class LocalUser {
  LocalUser({
    String? accessToken,
    String? email,
    String? password
  }) {
    _accessToken = accessToken;
    _email = email;
    _password = password;
  }

  LocalUser.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _email = json['email'];
    _password = json['password'];
  }

  String? _accessToken;
  String? _email;
  String? _password;

  String? get accessToken => _accessToken;

  String? get email => _email;

  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['email'] = _email;
    map['password'] = _password;
    return map;
  }
}
