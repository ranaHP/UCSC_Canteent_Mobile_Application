// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ucsc_canteen_19001355/home_screen.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';

class UcscSplashScreen extends StatefulWidget {
  const UcscSplashScreen({Key? key}) : super(key: key);

  @override
  State<UcscSplashScreen> createState() => _UcscSplashScreenState();
}

class _UcscSplashScreenState extends State<UcscSplashScreen> {
  @override
  void initState() {
    super.initState();

    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
  }

  route() async {
    // ignore: await_only_futures
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(image: AssetImage("assets/images/logo_c.png"), height: 250),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 3,
              color: Colors.orange,
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "University of Colombo School of Computing Canteen",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 1)
                    ]),
              )),
        ],
      ),
    );
  }
}
