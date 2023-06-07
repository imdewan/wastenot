import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _formKey = GlobalKey<FormState>();
  var rememberValue = false;
  final city = TextEditingController();
  final address = TextEditingController();
  final mobile = TextEditingController();
  final food = TextEditingController();
  final nameController = TextEditingController();
  //Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Meal'),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          prefixIcon: const Icon(Icons.account_box),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: food,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter food name';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Name of meal',
                          prefixIcon: const Icon(Icons.restaurant),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: address,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter address',
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: mobile,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter mobile number',
                          prefixIcon: const Icon(Icons.call),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: city,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter city name';
                          }
                          return null;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter City name',
                          prefixIcon: const Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          if (_formKey.currentState!.validate()) {}
                          var db = FirebaseFirestore.instance;

                          // Create a new user with a first and last name
                          final meal = <String, dynamic>{
                            "name": food.text,
                            "donor": nameController.text,
                            "city": city.text,
                            "contact": mobile.text,
                            "location": address.text,
                            "datetime": FieldValue.serverTimestamp(),
                            "email": prefs.getString('email')!,
                          };
                          db.collection("meals").add(meal).then(
                              (DocumentReference doc) => print(
                                  'DocumentSnapshot added with ID: ${doc.id}'));
                          Fluttertoast.showToast(msg: "Added Successfully");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

Future<String> makePostRequest(email, password, name) async {
  //edited the .htaccess
  final url = Uri.parse('https://ipreferlambo.com/api/register-api.php');
  final headers = {"Content-type": "application/json"};
  var json = '{"email": "' +
      email +
      '", "password": "' +
      password +
      '", "name": "' +
      name +
      '"}';
  final response = await post(url, headers: headers, body: json);
  print(email + password);
  print('Status code: ${response.statusCode}');
  print('Body: ${response.body}');
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return '{"error":"Network Error"}';
  }
}
