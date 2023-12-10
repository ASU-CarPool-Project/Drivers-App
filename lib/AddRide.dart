import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'MyWidgets.dart';
import 'home.dart';

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
  TextEditingController dateinput = TextEditingController();

  // DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedGate;
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
                          color: Colors.white70,
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
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: "Select Gate",
                            icon: Icon(Icons.door_sliding),
                          ),
                          value: _selectedGate,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGate = value;
                            });
                          },
                          items: [
                            'Gate 1',
                            'Gate 2',
                            'Gate 3',
                            'Gate 4',
                            'Gate 5',
                            'Gate 6',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Please select a gate");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_city),
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: "Location... ex: Maadi, Rehab",
                          ),
                          controller: _controllerRoute,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                        TextField(
                          controller: dateinput,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              //icon of text field
                              labelText: "Enter Date" //label text of field
                              ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                dateinput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                        TextFormField(
                          controller: _controllerTime,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.alarm),
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: "Time",
                          ),
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _selectedTime = pickedTime;
                                _controllerTime.text =
                                    _selectedTime!.format(context);
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.car_crash),
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: "Car Model",
                          ),
                          controller: _controllerCar,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.event_seat),
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: "Car Capacity",
                          ),
                          controller: _controllerCapacity,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.currency_pound),
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: "Trip Fee",
                          ),
                          controller: _controllerFee,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ("Can't be Empty");
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(colorsPrimary!),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        direction =
                            _selectedRouteDirection.toString().split('.').last;

                        DatabaseReference databaseReference =
                            FirebaseDatabase.instance.ref();
                        await databaseReference.child(direction!).push().set({
                          "driverID": userID,
                          "direction": direction,
                          "route": _controllerRoute.text,
                          "name": username,
                          "phone": phone,
                          "car": _controllerCar.text,
                          "capacity": _controllerCapacity.text,
                          "time": _controllerTime.text,
                          "date": dateinput.text,
                          "gate": _selectedGate,
                          "fee": _controllerFee.text,
                        });

                        _controllerRoute.clear();
                        _controllerCar.clear();
                        _controllerCapacity.clear();
                        _controllerFee.clear();
                        _controllerTime.clear();
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
