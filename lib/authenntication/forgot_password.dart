import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'utils.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
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
            controller: emailController,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
            email != null && !EmailValidator.validate(email)
                ? 'Enter a valid Email'
                :null,
          ),
        )
      ],
    );
  }

  Widget buildResetBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        icon: const Icon(Icons.email_outlined),
        label: const Text(
          'Reset Password',
          style: TextStyle(fontSize: 24),
        ),
        onPressed: verifyEmail,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.blueGrey,
    appBar: AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        'Reset Password',
        selectionColor: Colors.white,
      ),
    ),
    body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Form(
          key: formKey,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
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
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height*0.07, 20, 0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Receive an email to \nreset your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildEmail(),
                      const SizedBox(height: 20),
                      buildResetBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );

  Future verifyEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),

    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Password Reset Email Sent');
      Future.delayed(Duration.zero).then((value) =>
          Navigator.of(context).popUntil((route) => route.isFirst)
      );

    }on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}

