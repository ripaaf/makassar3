import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:itsla_maintenance/register.dart';
import 'package:itsla_maintenance/utils.dart';
import 'login.dart';
// import 'utils.dart';
// import 'login.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool isLoginForm = false;

  void toggleForm() {
    setState(() {
      isLoginForm = !isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'itsla maintenance',
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        nextRoute: LoginPage(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Widget nextRoute;

  const SplashScreen({required this.nextRoute});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextRoute();
  }

  void navigateToNextRoute() async {
    LoginPage();
    await Future.delayed(
        Duration(seconds: 2)); // Add a delay for the splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => widget.nextRoute),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/cunetnoisescalelevel0x25-2.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
