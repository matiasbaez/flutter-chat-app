
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ChatPage extends StatefulWidget {
  const ChatPage({ Key? key }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();

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
                itemBuilder: ( _, index ) => Text('$index')
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
                onChanged: (String value) {},
                decoration: const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4 ),
              child: kIsWeb
                ? _sendButton()
                : Platform.isIOS ? CupertinoButton(onPressed: () {}, child: const Text('Enviar')) : _sendButton()
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
        icon: Icon( Icons.send, color: Colors.blue[400], ),
        onPressed: () {}
      )
    );
  }

  _handleSubmit(String value) {
    _focusNode.requestFocus();
    _textCtrl.clear();
  }

}