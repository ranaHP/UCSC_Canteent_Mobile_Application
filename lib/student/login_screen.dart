import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucsc_canteen_19001355/authentication.dart';
import 'package:ucsc_canteen_19001355/home_screen.dart';
import 'package:ucsc_canteen_19001355/main.dart';
import 'package:ucsc_canteen_19001355/staff/login_screen_staff.dart';
import 'package:ucsc_canteen_19001355/student/food_page%20.dart';
import 'package:ucsc_canteen_19001355/student/registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController EmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              child: const Text(
                'Go to Sing Up',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationStudent()));
              },
            ),
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
    AuthenticationHelper()
        .signIn(
            email: EmailController.text,
            password: passwordController.text,
            role: "student")
        .then((result) {
      if (result == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => StudentFoodScreen()));
      } else {
        _showMyDialog(result);
      }
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (result != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const StudentFoodScreen()));
      } else {
        _showMyDialog("No user available for this email");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
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
                'Student Portal',
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
                  login();
                },
              )),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('OR'),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 0, bottom: 15),
              child: Center(
                child: MaterialButton(
                  elevation: 10,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/googleimage.png'),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text("Signin with Google")
                    ],
                  ),

                  // by onpressed we call the function signup function
                  onPressed: () => {signup(context)},
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Does not have account?'),
              TextButton(
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationStudent()));
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
                  'Staff Account.',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreenStaff()));
                },
              ),
            ],
          ),
        ],
      )),
    );
  }
}
