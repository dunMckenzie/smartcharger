import 'package:charger/authenntication/sign_up.dart';
import 'package:flutter/material.dart';

import 'log_in.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) =>
      isLogin ? LogIn(onClickedSignUp: toggle)
          : SignUp(onClickedSignIn: toggle);

  void toggle() => setState(() {
    isLogin = !isLogin;
  });
}
