// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ucsc_canteen_19001355/authentication.dart';
import 'package:ucsc_canteen_19001355/staff/canteen_home_page.dart';
import 'package:ucsc_canteen_19001355/student/login_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';

const List<String> list = <String>['true', 'false'];

class FoodItem {
  String? name;
  String? price;
  String? image;
  String? docId;
  String? available;

  FoodItem();

  Map<String, dynamic> tojson() => {
        'name': name,
        'price': price,
        "image": image,
        "docId": docId,
        "available": available
      };

  FoodItem.fromSnapshot(snapshot)
      : name = snapshot.data()['name'],
        price = snapshot.data()['price'],
        image = snapshot.data()['image'],
        docId = snapshot.data()['docId'],
        available = snapshot.data()['available'];
}

class StaffFoodScreen extends StatefulWidget {
  const StaffFoodScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StaffFoodScreenState createState() => _StaffFoodScreenState();
}

class _StaffFoodScreenState extends State<StaffFoodScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  void initState() {
    super.initState();
    // getAllFoodItems();
    getData();
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
          });
          print('Document data: ${data}');
        } on StateError catch (e) {
          print('No nested field exists!');
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  dynamic data;
  Future<void> _showMyDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adding Food Item',
              style: TextStyle(color: Colors.black87)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Form - ', style: TextStyle(color: Colors.black54)),
                Container(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Food Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                    ),
                    child: const Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Background color
              ),
              child: const Text(
                'Cansle',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
              ),
              child: const Text('Submit',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: () {
                final CollectionReference _collectionRef =
                    FirebaseFirestore.instance.collection('food_item');
                _collectionRef
                    .doc(nameController.text + nameController.text + "DocIDUSC")
                    .set({
                  "docId":
                      nameController.text + nameController.text + "DocIDUSC",
                  "name": nameController.text,
                  "price": priceController.text,
                  "available": true,
                  "image":
                      "https://www.nfpb.lk/wp-content/uploads/2022/10/plate-done-343x338.png"
                });
                getData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogforUpdate(
      String name, String price, String image, String docId) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    nameController.text = name;
    priceController.text = price;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Food Item',
              style: TextStyle(color: Colors.black87)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Form - ', style: TextStyle(color: Colors.black54)),
                Container(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Food Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                    ),
                    child: const Text(
                      'Upload Image',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Background color
              ),
              child: const Text(
                'Cansle',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
              ),
              child: const Text('Submit',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: () {
                final CollectionReference _collectionRef =
                    FirebaseFirestore.instance.collection('food_item');
                _collectionRef.doc(docId).update({
                  "name": nameController.text,
                  "price": priceController.text,
                  "image":
                      "https://www.nfpb.lk/wp-content/uploads/2022/10/plate-done-343x338.png"
                });
                getData();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<FoodItem> _myfoodItemList = [];
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('food_item');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _myfoodItemList = List.from(
          querySnapshot.docs.map((doc) => FoodItem.fromSnapshot(doc)));
    });

    // print(asd = allData.map((e) => e));
    // print("asd");

    // print(asd.elementAt(1));
    // print(allData.elementAt(1));

    // setState(() {
    //   _myfoodItemList = allData as List<Object>;
    // });
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
                                SizedBox(height: 25),
                                Text(
                                  'Food Item Center',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange),
                                ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: (() {
                                    _showMyDialog();
                                  }),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.amber),
                                  ),
                                  child: Row(children: const [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    const Text(
                                      "Add Food",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                ),
                              ],
                            )),
                        Container(
                          color: Colors.white54,
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _myfoodItemList.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                height: 200,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 234, 231, 231),
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
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image(
                                      image: NetworkImage(_myfoodItemList[index]
                                          .image
                                          .toString()),
                                      height: 120,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              " Name ",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${_myfoodItemList[index].name.toString()}",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              " Price (Rs)",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${_myfoodItemList[index].price.toString()}.00",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: (() {
                                            _showMyDialogforUpdate(
                                                _myfoodItemList[index]
                                                    .name
                                                    .toString(),
                                                _myfoodItemList[index]
                                                    .price
                                                    .toString(),
                                                _myfoodItemList[index]
                                                    .image
                                                    .toString(),
                                                _myfoodItemList[index]
                                                    .docId
                                                    .toString());
                                          }),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.amber),
                                          ),
                                          child: Row(children: const [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ]),
                                        ),
                                        ElevatedButton(
                                          onPressed: (() {
                                            final CollectionReference
                                                _collectionRef =
                                                FirebaseFirestore.instance
                                                    .collection('food_item');
                                            _collectionRef
                                                .doc(_myfoodItemList[index]
                                                    .docId)
                                                .delete();
                                            getData();
                                          }),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                          ),
                                          child: Row(children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ]),
                                        ),
                                        ElevatedButton(
                                          onPressed: (() {
                                            final CollectionReference
                                                _collectionRef =
                                                FirebaseFirestore.instance
                                                    .collection('food_item');
                                            _collectionRef
                                                .doc(_myfoodItemList[index]
                                                    .docId)
                                                .update({
                                              "available":
                                                  _myfoodItemList[index]
                                                              .available
                                                              .toString() ==
                                                          "true"
                                                      ? "false"
                                                      : "true"
                                            });
                                            getData();
                                          }),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green),
                                          ),
                                          child: Row(children: [
                                            Icon(
                                              _myfoodItemList[index]
                                                          .available
                                                          .toString() ==
                                                      "false"
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white,
                                            ),
                                          ]),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Image(image: NetworkImage(c_user.photoURL)),
                        const SizedBox(height: 40),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const StaffHomeScreen();
                            }));
                          },
                          color: Colors.red,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: const Text(
                              'Home',
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
