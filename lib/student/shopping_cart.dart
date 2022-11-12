// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ucsc_canteen_19001355/authentication.dart';
import 'package:ucsc_canteen_19001355/student/food_page%20.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> list = <String>['true', 'false'];

class FoodItem {
  String? name;
  String? price;
  String? image;
  String? docId;
  String? available;
  String? SpecialNote;
  String? quantity;
  String? orderedQuantity;

  FoodItem();

  Map<String, dynamic> tojson() => {
        'name': name,
        'price': price,
        "image": image,
        "docId": docId,
        "available": available,
        "SpecialNote": SpecialNote,
        "orderedQuantity": orderedQuantity
      };

  FoodItem.fromSnapshot(snapshot)
      : name = snapshot.data()['name'],
        price = snapshot.data()['price'],
        image = snapshot.data()['image'],
        docId = snapshot.data()['docId'],
        available = snapshot.data()['available'],
        SpecialNote = snapshot.data()['SpecialNote'],
        orderedQuantity = snapshot.data()['orderedQuantity'];
}

class ShoopingCartFoodItem {
  String? docId;
  List<FoodItem>? item;
  ShoopingCartFoodItem();

  Map<String, dynamic> tojson() => {"docId": docId, "item": item};

  ShoopingCartFoodItem.fromSnapshot(snapshot)
      : docId = snapshot.data()['docId'],
        item = List<FoodItem>.from(
            snapshot.data()['item'].map((data) => FoodItem.fromSnapshot(data)));
}

class StudentShoopingCartcreen extends StatefulWidget {
  const StudentShoopingCartcreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StudentShoopingCartcreenState createState() =>
      _StudentShoopingCartcreenState();
}

class _StudentShoopingCartcreenState extends State<StudentShoopingCartcreen> {
  String UserName = "";
  String email = "";
  String image = "";
  String userid = "Vg9FD34y1GTwpNhWPiuSMDjgKlc2";

  @override
  void initState() {
    super.initState();
    getUserData();
    getData();
  }

  dynamic data;

  Future<void> _showMyDialogAddtoCart(FoodItem fi) async {
    TextEditingController quantityController = TextEditingController();
    quantityController.text = "1";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Food Item Details',
              style: TextStyle(color: Colors.black87)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name - ${fi.name} ',
                    style: TextStyle(color: Colors.black54)),
                Text('Price - Rs ${fi.price}.00 ',
                    style: TextStyle(color: Colors.black54)),
                Text(
                    'Special Note - ${fi.SpecialNote == null ? "no" : fi.SpecialNote} ',
                    style: TextStyle(color: Colors.black54)),
                Container(height: 10),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: (Image.network(fi.image == ""
                        ? 'https://i.imgur.com/sUFH1Aq.png'
                        : fi.image.toString()))),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantity',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey, // Background color
                ),
                child: const Text(
                  'Cansel',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onPressed: () async {
                  final CollectionReference _collectionRef =
                      FirebaseFirestore.instance.collection('user_cart');

                  FirebaseFirestore.instance
                      .collection('user_cart')
                      .doc(userid)
                      .get()
                      .then((DocumentSnapshot documentSnapshot) async {
                    if (documentSnapshot.exists) {
                      List<dynamic> oldTempItem = [];
                      print('shooping cart data : ${documentSnapshot.data()}');
                      oldTempItem =
                          await documentSnapshot.get(FieldPath(['item']));

                      fi.orderedQuantity = quantityController.text;
                      oldTempItem.add(fi.tojson());

                      print('shooping cart data old : $oldTempItem');
                      _collectionRef.doc(userid).set({
                        "docId": userid,
                        "quantity": quantityController.text,
                        "item": oldTempItem
                      });
                      // try {
                      //   setState(() {
                      //     canteenOpenCloseStatus =
                      //         documentSnapshot.get(FieldPath(['value']));
                      //   });
                      //   print('Document data: ${data}');
                      // } on StateError catch (e) {
                      //   print('No nested field exists!');
                      // }
                    } else {
                      print('Document does not exist on the database');
                    }
                  });

                  getData();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<dynamic> _myfoodItemList = [];

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('user_cart');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List

    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      // _myfoodItemList = allData.toList();
    });
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
      email = user.email.toString();
      UserName = user.displayName.toString();
      image = user.photoURL.toString();
      userid = user.uid.toString();
    }
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
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage("assets/images/logo.png"),
                            height: 100,
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'Welcome to UCSC Canteen ',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Presented by Hansana Ranaweera 19001355 ',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 15, color: Colors.white60),
                          ),
                          const SizedBox(height: 10),
                          UserName != ""
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 25),
                                    image != ""
                                        ? Image(
                                            image: NetworkImage(image),
                                            height: 40,
                                          )
                                        : const SizedBox(
                                            width: 0,
                                          ),
                                    image != ""
                                        ? const SizedBox(
                                            height: 20,
                                          )
                                        : const SizedBox(
                                            height: 0,
                                          ),
                                    Text(
                                      UserName == "" ? "" : UserName,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white60),
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                          const SizedBox(height: 25),
                          const Text(
                            'Your Shopping Cart Items ',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white54,
                      padding: const EdgeInsets.all(10),
                      height: 800,
                      child: _myfoodItemList.length > 0
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: false,
                              itemCount: _myfoodItemList.length,
                              itemBuilder: ((context, index) {
                                return Container(
                                    height: 200,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 234, 231, 231),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shadowColor: Colors.orange,
                                      ),
                                      onPressed: () => {
                                        _showMyDialogAddtoCart(
                                            _myfoodItemList[index])
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Image(
                                            image: NetworkImage(
                                                _myfoodItemList[index]
                                                    .item[0]
                                                    .image
                                                    .toString()),
                                            height: 150,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    " Name ",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "${_myfoodItemList[index].item[0].name.toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Text(
                                                    " Price (Rs)",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "${_myfoodItemList[index].item[0].price.toString()}.00",
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                              }))
                          : Center(child: CircularProgressIndicator()),
                    ),
                    const SizedBox(height: 40),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const StudentFoodScreen()));
                        ;
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        }), ModalRoute.withName('/'));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Home',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
