
import 'package:flutter/material.dart';

import 'package:chat/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Logo( title: 'Messenger' ),

                _LoginForm(),

                Labels(
                  route: 'register',
                  title: '¿No tienes una cuenta?',
                  subtitle: 'Crea una cuenta',
                ),

                Text('Términos y condiciones de uso', style: TextStyle( fontWeight: FontWeight.w200))

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( top: 40 ),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            textController: emailCtrl
          ),

          CustomInput(
            icon: Icons.lock,
            placeholder: 'Password',
            isPassword: true,
            textController: passwordCtrl,
          ),

          CustomButton(
            text: 'Login',
            onPressed: () {}
          )
        ],
      ),
    );
  }
}
