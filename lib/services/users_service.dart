
import 'package:dio/dio.dart';

import 'package:chat/services/services.dart';
import 'package:chat/models/models.dart';

class UsersService {
  
  Future<List<User>> getUsers() async {
    try {

      final response = await dio.get(
        '/users', 
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken()
          }
        )
      );

      if (response.statusCode == 200) {
        final body = usersResponseFromMap(response.data);
        return body.data;
      }

      return [];

    } catch(error) {
      return [];
    }
  }

}