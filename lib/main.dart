
import 'package:charger/authenntication/auth_page.dart';
import 'package:charger/authenntication/sign_up.dart';
import 'package:charger/authenntication/utils.dart';
import 'package:charger/authenntication/verify_email.dart';
import 'package:charger/pages/home_page.dart';
import 'package:charger/pages/settings.dart';
import 'package:charger/authenntication/table_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  static const String title = 'Setup Firebase';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    scaffoldMessengerKey: Utils.messengerKey,
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home:  MainPage()
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const VerifyEmail();
            } else {
              return const AuthPage();
            }
          }),


  );

}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final items = const [
    Icon(Icons.home, size: 30),
    Icon(Icons.view_list_sharp, size: 30),
    Icon(Icons.settings, size: 30),
  ];

  int index = 1 ;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 60,
        backgroundColor: Colors.white,
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.indigoAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: Container(
        color: Colors.blue,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: getSelectedWidget(index: index),
      ),
    );
  }
  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const HomeScreen();
        break;
      case 1:
        widget = const TableScreen();
        break;
      default:
        widget = Settings() as Widget;
        break;

    }
    return widget;
  }
}


