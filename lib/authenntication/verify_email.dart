import 'dart:async';

import 'package:charger/authenntication/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../pages/home_page.dart';


class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    //user needs to be created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    //call after email verication
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }


  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomeScreen()
      : Scaffold(
    appBar: AppBar(
      title: const Text(
        'Verify Email',
      ),
      backgroundColor: Colors.black,
    ),
    body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: [
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
                  padding: EdgeInsets.fromLTRB(20,
                      MediaQuery.of(context).size.height * 0.07, 20, 0),
                  child: Column(children: <Widget>[
                    const Text(
                      'A verification email has been sent to your email',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.email, size: 32),
                      label: const Text(
                        'Reset Email',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed:
                      canResendEmail ? sendVerificationEmail : null,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        'cancel',
                        style: TextStyle(fontSize: 24),
                      ),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                    ),
                  ])),
            ),
          ],
        ),
      ),
    ),
  );
}
