
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/services.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:chat/helpers/alert.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({ Key? key }) : super(key: key);

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

                Logo( title: 'Registro' ),

                _LoginForm(),

                Labels(
                  route: 'login',
                  title: 'Ya tienes una cuenta?',
                  subtitle: 'Inicia sesión',
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

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only( top: 40 ),
      padding: const EdgeInsets.symmetric( horizontal: 50 ),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.person,
            placeholder: 'Name',
            textController: nameCtrl
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl
          ),

          CustomInput(
            icon: Icons.lock,
            placeholder: 'Password',
            isPassword: true,
            textController: passwordCtrl,
          ),

          CustomButton(
            text: 'Register',
            onPressed: authService.loading ? null : () async {
              FocusScope.of(context).unfocus();
              final success = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passwordCtrl.text.trim());
              if (success) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
                return;
              }

              showAlert(context, 'Register', 'The data provide are incomplete');
            }
          )
        ],
      ),
    );
  }
}
