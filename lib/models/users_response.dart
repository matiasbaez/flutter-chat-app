
import 'dart:convert';

import 'package:chat/models/models.dart';

UsersResponse usersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));
UsersResponse usersResponseFromMap(Map<String, dynamic> map) => UsersResponse.fromMap(map);
String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {

  bool ok;
  List<User> data;

  UsersResponse({
    required this.ok,
    required this.data,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
    ok: json["ok"],
    data: List<User>.from(json["data"].map((x) => User.fromJson(x))),
  );

  factory UsersResponse.fromMap(Map<String, dynamic> map) => UsersResponse(
    ok: map["ok"],
    data: List<User>.from(map["data"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

}
