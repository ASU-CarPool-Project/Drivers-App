import 'package:asu_carpool_driver/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'MyWidgets.dart';
String? direction = "";

class AddRide extends StatefulWidget {
  const AddRide({Key? key}) : super(key: key);

  @override
  State<AddRide> createState() => _AddRideState();
}
enum RouteDirection { ToCollege, FromCollege }

class _AddRideState extends State<AddRide> {
  RouteDirection? _selectedRouteDirection = RouteDirection.ToCollege;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _controllerRoute = TextEditingController();
  final TextEditingController _controllerCar = TextEditingController();
  final TextEditingController _controllerCapacity = TextEditingController();
  final TextEditingController _controllerFee = TextEditingController();
  final TextEditingController _controllerTime = TextEditingController();
  final TextEditingController  _controllerWaitingTime = TextEditingController();
  double boxHeight = 30.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsPrimary,
        leading: iconBack(context),
        title: textPageTitle("Add Rides"),
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
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(5),
                                child: Text("Choose your direction"),
                              ),
                              ListTile(
                                title: const Text('To College'),
                                leading: Radio(
                                  value: RouteDirection.ToCollege,
                                  groupValue: _selectedRouteDirection,
                                  onChanged: (RouteDirection? value) {
                                    setState(() {
                                      _selectedRouteDirection = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('From College'),
                                leading: Radio(
                                  value: RouteDirection.FromCollege,
                                  groupValue: _selectedRouteDirection,
                                  onChanged: (RouteDirection? value) {
                                    setState(() {
                                      _selectedRouteDirection = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "Route Description"),
                          controller: _controllerRoute,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
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
                              hintText: "Car Model"),
                          controller: _controllerCar,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
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
                              hintText: "Car Capacity"),
                          controller: _controllerCapacity,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
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
                              hintText: "Time"),
                          controller: _controllerTime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
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
                              hintText: "Waiting Time"),
                          controller: _controllerWaitingTime,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
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
                              hintText: "Trip Fee"),
                          controller: _controllerFee,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: boxHeight,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(colorsPrimary!),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        //below is the name of the child that we will push to
                        direction = _selectedRouteDirection.toString().split('.').last;

                        DatabaseReference databaseReference =
                        FirebaseDatabase.instance.ref();
                        await databaseReference.child(direction!).push().set({
                          "direction": direction,
                          "route": _controllerRoute.text,
                          "name": username,
                          "phone": phone,
                          "car": _controllerCar.text,
                          "capacity": _controllerCapacity.text,
                          "time": _controllerTime.text,
                          "waiting": _controllerWaitingTime.text,
                          "fee": _controllerFee.text,
                        });

                        // Clear text controllers
                        _controllerRoute.clear();
                        _controllerCar.clear();
                        _controllerCapacity.clear();
                        _controllerFee.clear();
                        _controllerTime.clear();
                        _controllerWaitingTime.clear();
                      } catch (e) {
                        print("Error adding trip to Firebase: $e");
                      }
                    }
                  },
                  child: textButtons("Add Trip"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
