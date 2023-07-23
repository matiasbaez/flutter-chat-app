
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';

class AuthService extends ChangeNotifier {

  late User user;
  bool _loading = false;

  // Create storage
  final _storage = const FlutterSecureStorage();

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token ?? '';
  }

  static Future<void> removeToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }
  
  Future<bool> login( String email, String password ) async {

    loading = true;

    final data = {
      'email': email,
      'password': password
    };

    final url = Uri.http('${Environment.apiURL}/login');
    final response = await http.post(url, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    loading = false;

    if (response.statusCode == 200) {
      final data = loginResponseFromJson(response.body);
      user = data.user;
      await _saveToken(data.token);
      return true;
    }

    return false;

  }

  Future register( String name, String email, String password ) async {

    loading = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final url = Uri.http('${Environment.apiURL}/register');
    final response = await http.post(url, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    loading = false;

    if (response.statusCode == 200) {
      final data = loginResponseFromJson(response.body);
      user = data.user;
      await _saveToken(data.token);
      return true;
    }

    final body = jsonDecode(response.body);
    return body["message"];

  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final url = Uri.http('${Environment.apiURL}/login/renew');
    final response = await http.post(url, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': 'Bearer $token'
      }
    );

    if (response.statusCode == 200) {
      final data = loginResponseFromJson(response.body);
      user = data.user;
      await _saveToken(data.token);
      return true;
    }

    _logout();
    return false;
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    return await _storage.delete(key: 'token');
  }

}