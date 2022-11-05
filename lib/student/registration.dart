import 'package:flutter/material.dart';
import 'package:ucsc_canteen_19001355/authentication.dart';
import 'package:ucsc_canteen_19001355/main.dart';
import 'package:ucsc_canteen_19001355/staff/login_screen_staff.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class RegistrationStudent extends StatefulWidget {
  const RegistrationStudent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationStudentState createState() => _RegistrationStudentState();
}

class _RegistrationStudentState extends State<RegistrationStudent> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _showMyDialog(String result) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Fails',
              style: TextStyle(color: Colors.red)),
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
              child: const Text(
                'Go to SingIn',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
            TextButton(
              child: const Text('Try Another Email'),
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

  Future<void> _showSuccessRegistration() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Registration Success',
            style: TextStyle(color: Colors.green),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Message - '),
                Text(
                    "You are successfully registered to University of Colombo school of Computing Canteen"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to SingIn'),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  void login() {
    AuthenticationHelper()
        .signUp(email: EmailController.text, password: passwordController.text)
        .then((result) {
      if (result == null) {
        _showSuccessRegistration();
      } else {
        _showMyDialog(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Staff',
                style: TextStyle(fontSize: 20),
              )),

          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Registration Form',
                style: TextStyle(fontSize: 15, color: Colors.orangeAccent),
              )),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: EmailController,
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
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () {
                  print(EmailController.text);
                  print(passwordController.text);
                  login();
                },
              )),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Already have an account?'),
              TextButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreenStaff()));
                },
              )
            ],
          ),
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
