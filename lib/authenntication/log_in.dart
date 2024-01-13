import 'package:charger/authenntication/utils.dart';
import 'package:charger/authenntication/forgot_password.dart';
import 'package:charger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class LogIn extends StatefulWidget {

  final VoidCallback onClickedSignUp;
  static final user = FirebaseAuth.instance.currentUser;
  const LogIn({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Email',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            )
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color:  Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: 50,
          child: const TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              style:  TextStyle(
                  color: Colors.black87
              ),
              decoration: InputDecoration(border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.black38))
          ),
        ),
      ],
    );
  }
  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 50,
          child: TextField(
            controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                  hintText: 'password',
                  hintStyle: TextStyle(color: Colors.black38))),
        )
      ],
    );
  }

  Widget buildForgotBtn() {
    return Container(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: const Text(
            'Forgot Password',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
             builder: ((context) => const ForgotPassword()))),
        ));
  }

  Widget buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
      onPressed: signIn,
      child: const Text('LOGIN',
          style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget buildSignUpBtn() {
    return RichText(
        text: TextSpan(children: [
          const TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic)),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
            text: 'Sign Up',
            style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )
        ]));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
              children: <Widget> [
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/batt.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.07, 20, 0),
                    child: Column(
                        children: <Widget> [
                          const SizedBox(
                            height: 30,
                            width: 30,
                          ),
                          logoWidget('assets/img.png'),
                          const SizedBox(
                              height: 30
                          ),

                          buildEmail(),
                          const SizedBox(
                            height: 30,
                          ),
                          buildPassword(),
                          const SizedBox(
                            height: 30,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          buildForgotBtn(),
                          const SizedBox(
                            height: 5,
                          ),
                          buildLoginBtn(),
                          buildSignUpBtn()
                        ]
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
  Image logoWidget(String imageName) {
    return Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 100,
      height: 100,
    );
  }
  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil(
          (route) => route.isFirst,
    );
  }
}
