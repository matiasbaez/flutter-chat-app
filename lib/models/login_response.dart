
import 'dart:convert';

import 'package:chat/models/models.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
LoginResponse loginResponseFromMap(Map<String, dynamic> map) => LoginResponse.fromMap(map);
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {

  bool ok;
  User user;
  String token;

  LoginResponse({
    required this.ok,
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    ok: json["ok"],
    user: json["user"],
    token: json["token"],
  );

  factory LoginResponse.fromMap(Map<String, dynamic> map) => LoginResponse(
    ok: map["ok"],
    user: map["user"],
    token: map["token"],
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "user": user,
    "token": token,
  };

}
