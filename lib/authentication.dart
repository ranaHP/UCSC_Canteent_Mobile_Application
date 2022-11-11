import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future signUp({required String email, required String password, String? role}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final SharedPreferences prefs = await _prefs;
      if( role == "student") {
        await prefs.remove('current_role');
        await prefs.setString('current_role', "student");
      }else {
        await prefs.remove('current_role');
        await prefs.setString('current_role', "staff");
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }

      return e.message;
    }
  }

  Future signIn({required String email, required String password, String? role}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final SharedPreferences prefs = await _prefs;
      if( role == "student") {
        await prefs.remove('current_role');
        await prefs.setString('current_role', "student");
      }else {
        await prefs.remove('current_role');
        await prefs.setString('current_role', "staff");
      }
        return null;

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }



  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}
