import 'package:flutter/material.dart';
import 'package:ucsc_canteen_19001355/authentication.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void signOutGoogle() async {
    await AuthenticationHelper().signOut();
    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Center(
                  child: Text(
                    'Welcome User',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                SizedBox(height: 40),
                Image.asset(
                  "assets/images/unthis.png",
                  scale: 5,
                ),
                SizedBox(height: 40),
                RaisedButton(
                  onPressed: () {
                    signOutGoogle();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }), ModalRoute.withName('/'));
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
