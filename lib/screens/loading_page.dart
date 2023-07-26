
import 'package:chat/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/services.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder(
        future: checkLoggedIn(context),
        initialData: null,
        builder: (context, snapshopt) {
          return const Center(
            child: Text('Loading')
          );
        }
      ),
    );
  }

  Future checkLoggedIn( BuildContext context ) async {

    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final isLoggedIn = await authService.isLoggedIn();

    if (isLoggedIn) {
      // Navigator.pushReplacementNamed(context, 'users');
      socketService.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___, ) => UsersPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
      return;
    }

    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___, ) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
  }
}