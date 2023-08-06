import 'package:flutter/material.dart';

import 'package:chat/services/services.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {

  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.uid,
    required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == authService.user.uid
          ? _myMessage()
          : _guestMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
        margin: const EdgeInsets.only( bottom: 5, left: 50, right: 5 ),
        padding: const EdgeInsets.all(8),
        child: Text(text, style: const TextStyle( color: Colors.white )),
      ),
    );
  }

  Widget _guestMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        ),
        margin: const EdgeInsets.only( bottom: 5, left: 5, right: 50 ),
        padding: const EdgeInsets.all(8),
        child: Text(text, style: const TextStyle( color: Colors.black87 )),
      ),
    );
  }
}