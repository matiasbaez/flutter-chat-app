
import 'package:flutter/material.dart';

import 'package:chat/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users'     : ( _ ) => const UsersPage(),
  'chat'      : ( _ ) => const ChatPage(),
  'login'     : ( _ ) => const LoginPage(),
  'register'  : ( _ ) => const RegisterPage(),
  'loading'   : ( _ ) => const LoadingPage(),
};
