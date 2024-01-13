import 'package:charger/authenntication/utils.dart';
import 'package:charger/main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class SignUp extends StatefulWidget {

  final VoidCallback onClickedSignIn;

  const SignUp({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0,2))
              ]
          ),
          height: 50,
          child: TextFormField(
            controller: emailController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            email != null && !EmailValidator.validate(email)
                ? 'Enter a valid email'
                : null,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Colors.blueAccent,),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)
            ),
          ),
        )
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
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold

          ),
        ),
        const SizedBox(height: 10,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)
                )
              ]
          ),
          height: 50,
          child: TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.next,
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 6
                ? 'Enter min. 6 characters'
                : null,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.blueAccent,),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black38)
            ),
          ),
        )
      ],
    );
  }

  Widget buildSignUpBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
       child: ElevatedButton(
        onPressed: signUp,
      child: const Text(
        'SIGN UP',
        style: TextStyle(
            color: Color(0xff5ac18e),
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),
      ),
      // ),
    )
    );
  }

  Widget buildSignInBtn() {
    return RichText(
        text: TextSpan(children: [
          const TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic
              )
          ),
          TextSpan(
             recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignIn,
              text: 'Sign In',
              style: const TextStyle(
                  color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold

              )
          )
        ])
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
            child: Stack(children: <Widget>[
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/batt.png',
                      ),
                      fit: BoxFit.cover,
                    )),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.07, 20, 0),
                  child: Column(
                    children: <Widget>[
                      logoWidget('assets/img.png'),
                      const SizedBox(height: 30),
                      buildEmail(),
                      const SizedBox(height: 20),
                      buildPassword(),
                      const SizedBox(height: 15),
                      buildSignUpBtn(),
                      const SizedBox(height: 10),
                      buildSignInBtn(),
                    ],
                  ),
                ),
              )
            ])),
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
  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil(
          (route) => route.isFirst,
    );
  }
}
