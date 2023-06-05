
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final Function()? onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      onPressed: onPressed,
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: const StadiumBorder(),
      disabledColor: Colors.grey,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(text, style: const TextStyle( color: Colors.white, fontSize: 18 )),
        ),
      ),
    );
  }
}