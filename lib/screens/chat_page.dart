
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import 'package:chat/services/services.dart';
import 'package:chat/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;

  late AuthService authService;
  late ChatService chatService;
  late SocketService socketService;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('private-message', _waitingMessage);
  }

  @override
  void dispose() {

    for (var message in _messages) {
      message.animationController.dispose();
    }

    socketService.socket.off('private-message');
    super.dispose();
  }

  void _waitingMessage( dynamic data ) {
    ChatMessage message = ChatMessage(
      text: data['message'],
      uid: data['from'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration( microseconds: 300 )
      )
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final user = chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(user.name.substring(0, 2), style: const TextStyle( fontSize: 12 )),
            ),

            const SizedBox(height: 3),

            Text(user.name, style: const TextStyle( color: Colors.black87, fontSize: 14 ),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemBuilder: ( _, index ) => _messages[index],
                itemCount: _messages.length,
              ),
            ),

            const Divider( height: 1 ),

            Container(
              color: Colors.white,
              child: _chatInput(),
            )
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 8 ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textCtrl,
                onSubmitted: _handleSubmit,
                onChanged: (String value) {
                  setState(() {
                    _isWriting = value.trim().isNotEmpty ? true : false;
                  });
                },
                decoration: const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4 ),
              child: kIsWeb
                ? _sendButton()
                : Platform.isIOS ? CupertinoButton(onPressed: _isWriting ? () => _handleSubmit(_textCtrl.text.trim()) : null, child: const Text('Enviar')) : _sendButton()
            )
          ],
        ),
      )
    );
  }

  Widget _sendButton() {
    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 4 ),
      child: IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon( Icons.send, color: _isWriting ? Colors.blue[400] : Colors.grey ),
        onPressed: _isWriting ? () => _handleSubmit(_textCtrl.text.trim()) : null
      )
    );
  }

  _handleSubmit(String value) {
    if (value.isEmpty) return;

    _focusNode.requestFocus();
    _textCtrl.clear();

    final newMessage = ChatMessage(
      text: value,
      uid: '1',
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 400 )),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    socketService.emit('private-message', {
      'from': authService.user.uid,
      'to': chatService.userTo.uid,
      'message': value
    });
  }

}