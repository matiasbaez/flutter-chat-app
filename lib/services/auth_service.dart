
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat/global/environment.dart';
import 'package:chat/models/models.dart';

final dio = Dio(BaseOptions(
  baseUrl: Environment.apiURL
));

class AuthService extends ChangeNotifier {

  User user = User(email: '', name: '', uid: '');
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

    try {

      final response = await dio.post(
       '/login',
        data: jsonEncode(data),
      );

      loading = false;

      if (response.statusCode == 200) {
        final data = response.data;
        user = userFromMap(data["user"]);
        await _saveToken(data["token"]);
        return true;
      }

      return false;

    } catch(error) {
      loading = false;
      return false;
    }
  }

  Future register( String name, String email, String password ) async {

    loading = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    try {

      final response = await dio.post(
       '/login/new',
        data: jsonEncode(data),
      );

      loading = false;

      if (response.statusCode == 200) {
        final data = response.data;
        user = userFromMap(data["user"]);
        await _saveToken(data["token"]);
        return true;
      }

      final body = response.data;
      return body["message"];

    } catch(error) {
      loading = false;
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {

      final token = await _storage.read(key: "token");
      final response = await dio.post(
       '/login/renew',
        options: Options(
          headers: {
            "x-token": token
          }
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        user = userFromMap(data["user"]);
        await _saveToken(data["token"]);
        return true;
      }

      _logout();
      return false;

    } catch(error) {
      _logout();
      return false;
    }

  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    return await _storage.delete(key: 'token');
  }

}