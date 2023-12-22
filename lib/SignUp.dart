import 'package:asu_carpool_driver/LocalDatabse.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MyWidgets.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //////////////////////////////////////////////////////////////////////////////

  LocalDatabase mydb = LocalDatabase();
  List<Map> mylist = [];

  //////////////////////////////////////////////////////////////////////////////
  ///
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  bool _isObscure = true;

  double boxHeight = 30.0;
  // static final RegExp _emailRegExp =
  //     RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");

  // For ASU emails that ends with @eng.asu.edu.eg us the below reg
  static final RegExp _emailRegExp =
      RegExp(r"^[a-zA-Z0-9._-]+@eng\.asu\.edu\.eg$");

  /////////////////////////////////////////////////////////////////////////////
  // final LocalDatabase db = LocalDatabase();

  // Future<void> writingData() async {
  //   // final userData = await fetchUserProfile();
  //   await db.write('''INSERT INTO 'USERS'
  //       ('FIRST_NAME','LAST_NAME','EMAIL','PHONE') VALUES
  //       ('${_controllerFirstName.text}',
  //       '${_controllerLastName.text}',
  //       '${_controllerEmail.text}',
  //       '${_controllerPhone.text}') ''');
  // }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _controllerEmail.text.trim(),
                password: _controllerPassword.text);

        //// Send verification email
        // await userCredential.user!.sendEmailVerification();
        // print("Verification email sent to ${userCredential.user!.email}");
        // toastMsg("Verification email sent to ${userCredential.user!.email}");

        // Store additional user data in Firestore
        await FirebaseFirestore.instance
            .collection('users_driver')
            .doc(userCredential.user!.uid)
            .set({
          'firstName': _controllerFirstName.text,
          'lastName': _controllerLastName.text,
          'email': _controllerEmail.text,
          'phone': _controllerPhone.text,
        });

        // writingData();

        // Reset the form after successful signup
        _formKey.currentState!.reset();
        // If sign-up is successful, navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const home()),
        );
      } on FirebaseAuthException catch (e) {
        print("Failed to sign up: $e");
        toastMsg("Sign-up Error: $e");
      }
    }
  }

  /////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsPrimary,
        leading: iconBack(context),
        title: textPageTitle("Sign Up"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "First Name",
                              icon: Icon(Icons.tag_faces),
                            ),
                            controller: _controllerFirstName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ("First Name is Empty");
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: boxHeight,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "Last Name",
                              icon: Icon(Icons.tag_faces_rounded),
                            ),
                            controller: _controllerLastName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ("Last Name is Empty");
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: boxHeight,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "Phone Number",
                              icon: Icon(Icons.phone),
                            ),
                            controller: _controllerPhone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ("Phone Number not entered");
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: boxHeight,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: "Email Address",
                                icon: Icon(Icons.email)),
                            controller: _controllerEmail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ("Check your Email Address");
                              } else if (!_emailRegExp.hasMatch(value)) {
                                return "Enter a valid email address";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: boxHeight,
                          ),
                          TextFormField(
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "Password",
                              icon: const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            controller: _controllerPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ("Enter Password");
                              } else if (value.length < 8) {
                                return "Password must be at least 8 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: boxHeight,
                          ),
                          TextFormField(
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "Confirm Password",
                              icon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            controller: _controllerConfirmPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ("Re-enter Password");
                              } else if (_controllerConfirmPassword.text !=
                                  _controllerPassword.text) {
                                return "Passwords doesn't match";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    )),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(colorsPrimary!),
                  ),
                  onPressed: _register,
                  child: textButtons("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
