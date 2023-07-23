
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/widgets.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ChatPage extends StatefulWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;

  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {

    for (var message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text('MB', style: TextStyle( fontSize: 12 )),
            ),

            const SizedBox(height: 3),

            const Text('Matías Báez', style: TextStyle( color: Colors.black87, fontSize: 14 ),)
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
  }

}