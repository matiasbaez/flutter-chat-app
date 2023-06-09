
class User {
  bool online;
  String email;
  String name;
  String uid;

  User({
    this.online = false,
    required this.email,
    required this.name,
    required this.uid
  });
}
