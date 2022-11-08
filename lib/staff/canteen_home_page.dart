// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ucsc_canteen_19001355/authentication.dart';
import 'package:ucsc_canteen_19001355/staff/canteen_food_page%20.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StaffHomeScreenState createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Stream<DocumentSnapshot> documentStream = FirebaseFirestore.instance
      .collection('current_status')
      .doc('15428652')
      .snapshots();

  void signOutGoogle() async {
    await AuthenticationHelper().signOut();
    print("User Sign Out");
  }

  int foodItemCount = 0;
  @override
  void initState() {
    super.initState();
    getUserData();
    getCanteenStatus();
  }

  Future getUserData() async {
    debugPrint("---------------getting user data ------------------");
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;
    if (user == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen()));
    } else {
      print(user);
      print('=======================');
      print(user.email);
    }
  }

  _tileClicked(String item) {
    if (item == "StaffFoodScreen") {}
  }

  Future changeCanteenStatus(int status) async {
    final FirebaseFirestore _cloud = await FirebaseFirestore.instance;
    _cloud
        .collection('current_status')
        .doc('15428652')
        .update({"value": status});
    getCanteenStatus();
  }

  Future getCanteenStatus() async {
    FirebaseFirestore.instance
        .collection('current_status')
        .doc("15428652")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        try {
          setState(() {
            data = documentSnapshot.get(FieldPath(['value']));
            return;
          });
          print('Document data: ${data}');
        } on StateError catch (e) {
          print('No nested field exists!');
        }
      } else {
        print('Document does not exist on the database');
      }
    });
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('food_item');

    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    // Get data from docs and convert map to List

    setState(() {
      foodItemCount = allData.length;
    });
  }

  dynamic data;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changing Canteen Open/Close Status',
              style: TextStyle(color: Colors.black87)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Message - ',
                    style: TextStyle(color: Colors.black54)),
                Container(height: 10),
                const Text("Do you want to close canteen now",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Background color
              ),
              child: const Text(
                'Close Canteen',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                changeCanteenStatus(0);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
              ),
              child: const Text('Open Canteen',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: () {
                changeCanteenStatus(1);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: double.infinity,
            color: Colors.orange,
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: double.infinity,
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Image(
                                  image: AssetImage("assets/images/logo.png"),
                                  height: 100,
                                ),
                                SizedBox(height: 25),
                                Text(
                                  'Welcome to Canteen Staff ',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Presented by Hansana Ranaweera 19001355 ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white60),
                                ),
                              ],
                            )),
                        Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            height: 175,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.teal,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(2,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Current Status",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    data == 1
                                                        ? "Open"
                                                        : "Closed",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: _showMyDialog,
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors
                                                          .teal, // Background color
                                                    ),
                                                    child: const Text(
                                                      "Change Status",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ), //Container
                                        ), //Flexible
                                        const SizedBox(
                                          width: 20,
                                        ), //SizedBox
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            height: 175,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.pinkAccent,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(2,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Current Orders",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const Text(
                                                    "0",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors
                                                          .pinkAccent, // Background color
                                                    ),
                                                    onPressed: (() {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginScreen()),
                                                      );
                                                    }),
                                                    child: const Text(
                                                      "Go to Orders",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ), //Container
                                        ),
                                      ], //<Widget>[]
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            height: 175,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.blueGrey,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(2,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Current Food Items",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "$foodItemCount",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors
                                                          .blueGrey, // Background color
                                                    ),
                                                    onPressed: (() {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const StaffFoodScreen()),
                                                      );
                                                    }),
                                                    child: const Text(
                                                      "Go to Foods",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ), //Container
                                        ), //Flexible
                                        const SizedBox(
                                          width: 20,
                                        ), //SizedBox
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            height: 175,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.brown,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: const Offset(2,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Special Request",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  const Text(
                                                    "0",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors
                                                          .brown, // Background color
                                                    ),
                                                    onPressed: _tileClicked(
                                                        'StaffSpecialRequest'),
                                                    child: const Text(
                                                      "Go to Special Request",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ), //Container
                                        ),
                                      ], //<Widget>[]
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                    ),
                                  ),

                                  //Row
                                ], //<Widget>[]
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ), //Column
                            ) //Padding
                            ),
                        const SizedBox(height: 40),
                        // Image(image: NetworkImage(c_user.photoURL)),
                        const SizedBox(height: 40),
                        RaisedButton(
                          onPressed: () {
                            signOutGoogle();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }), ModalRoute.withName('/'));
                          },
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: const Text(
                              'Sign Out',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                        )
                      ],
                    ),
                  )),
            )),
      ),
    );
  }
}
