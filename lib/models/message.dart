
import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));
Message messageFromMap(Map<String, dynamic> map) => Message.fromMap(map);
String messageToJson(Message data) => json.encode(data.toJson());

class Message {

  String to;
  String from;
  String message;
  String createdAt;
  String updatedAt;

  Message({
    required this.to,
    required this.from,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    to        : json["to"],
    from      : json["from"],
    message   : json["message"],
    createdAt : json["createdAt"],
    updatedAt : json["updatedAt"],
  );

  factory Message.fromMap(Map<String, dynamic> json) => Message(
    to        : json["to"],
    from      : json["from"],
    message   : json["message"],
    createdAt : json["createdAt"],
    updatedAt : json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "to"        : to,
    "from"      : from,
    "message"   : message,
    "createdAt" : createdAt,
    "updatedAt" : updatedAt,
  };
}
