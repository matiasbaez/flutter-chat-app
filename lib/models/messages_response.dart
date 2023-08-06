
import 'dart:convert';

import 'package:chat/models/models.dart';

MessagesResponse messagesResponseFromJson(String str) => MessagesResponse.fromJson(json.decode(str));
MessagesResponse messagesResponseFromMap(Map<String, dynamic> map) => MessagesResponse.fromMap(map);
String messagesResponseToJson(MessagesResponse data) => json.encode(data.toJson());

class MessagesResponse {

  bool ok;
  List<Message> data;

  MessagesResponse({
    required this.ok,
    required this.data,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) => MessagesResponse(
    ok: json["ok"],
    data: List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
  );

  factory MessagesResponse.fromMap(Map<String, dynamic> map) => MessagesResponse(
    ok: map["ok"],
    data: List<Message>.from(map["data"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

}
