
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:chat/models/models.dart';

class ChatService with ChangeNotifier {

  late User userTo;

  Future getChat( String userId ) async {
    try {

      final token = await AuthService.getToken();
      final response = await dio.get(
       '/messages/$userId',
        options: Options(
          headers: {
            "x-token": token
          }
        ),
      );

      if (response.statusCode == 200) {
        final body = response.data;
        final messages = messagesResponseFromMap(body["data"]);
        return messages;
      }

      final body = response.data;
      return body["message"];

    } catch(error) {
      return false;
    }
  }

}
