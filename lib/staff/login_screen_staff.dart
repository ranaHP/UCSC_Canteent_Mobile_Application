import 'package:flutter/material.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';

class LoginScreenStaff extends StatefulWidget {
  const LoginScreenStaff({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenStaffState createState() => _LoginScreenStaffState();
}

class _LoginScreenStaffState extends State<LoginScreenStaff> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
