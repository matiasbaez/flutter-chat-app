
import 'package:chat/services/services.dart';
import 'package:flutter/material.dart';

import 'package:chat/global/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService extends ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(
      Environment.socketURL,
      IO.OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      // .enableAutoConnect()
      // .disableAutoConnect()
      .enableReconnection()
      .enableForceNew()
      .setAuth({
        'x-token': token
      })
      .setExtraHeaders({
        'x-token': token
      })
      .build()
    );

    _socket.onConnectError((data) {});

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.on('message', (payload) {

    });

  }

  void disconnect() {
    _socket.disconnect();
  }

}
