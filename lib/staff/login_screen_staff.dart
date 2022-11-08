import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucsc_canteen_19001355/authentication.dart';
import 'package:ucsc_canteen_19001355/home_screen.dart';
import 'package:ucsc_canteen_19001355/staff/canteen_home_page.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';
import 'package:ucsc_canteen_19001355/student/registration.dart';

class LoginScreenStaff extends StatefulWidget {
  const LoginScreenStaff({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenStaffState createState() => _LoginScreenStaffState();
}

class _LoginScreenStaffState extends State<LoginScreenStaff> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> changeCurrentRole() async {
    final SharedPreferences prefs = await _prefs;
    // final int counter = (prefs.getInt('counter') ?? 0) + 1;
    prefs.setString('current_role', 'staff');
  }

  Future<void> _showMyDialog(String result) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Fails', style: TextStyle(color: Colors.red)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Reason - '),
                Container(height: 10),
                Text(result),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop();
                EmailController.clear();
                passwordController.clear();
              },
            ),
          ],
        );
      },
    );
  }

  void login() {
    EmailController.text = "staff@ucsc.com";
    passwordController.text = "abc123";
    // EmailController.text = "hansana876@gmail.com";
    // passwordController.text = "cybertcc123";

    AuthenticationHelper()
        .signIn(email: EmailController.text, password: passwordController.text)
        .then((result) {
      if (result == null) {
        changeCurrentRole();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StaffHomeScreen()));
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //     result,
        //     style: TextStyle(fontSize: 16),
        //   ),
        // ));
        _showMyDialog(result);
      }
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Image(
            image: AssetImage("assets/images/logo_c.png"),
            height: 200,
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'UCSC Canteen',
                style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              )),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 20),
              )),

          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Canteen Staff Portal',
                style: TextStyle(fontSize: 15, color: Colors.orangeAccent),
              )),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: EmailController,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     //forgot password screen
          //   },
          //   child: const Text(
          //     'Forgot Password',
          //   ),
          // ),
          Container(
              height: 50,
              width: 200,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: EdgeInsets.only(top: 30, bottom: 10),
              child: ElevatedButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  print(EmailController.text);
                  print(passwordController.text);
                  login();
                },
              )),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     const Text('Does not have account?'),
          //     TextButton(
          //       child: const Text(
          //         'Sign Up',
          //         style: TextStyle(fontSize: 18),
          //       ),
          //       onPressed: () {
          //         //signup screen
          //       },
          //     )
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Login'),
              TextButton(
                child: const Text(
                  'Student Account.',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
        ],
      )),
    );
  }
}
