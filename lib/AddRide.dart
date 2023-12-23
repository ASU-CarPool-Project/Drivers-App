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
  TextEditingController dateinput = TextEditingController();

  String? _selectedTime = "7:30 AM";
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
                                      _selectedTime = "7:30 AM";
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
                                      _selectedTime = "5:30 PM";
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
                            'Gate 3',
                            'Gate 4',
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
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today),
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
                              print(pickedDate);
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(formattedDate);
                              setState(() {
                                dateinput.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                        SizedBox(height: boxHeight),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: _selectedTime!,
                            icon: const Icon(Icons.timelapse),
                          ),
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
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.attach_money),
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
                          "driver": username,
                          "direction": direction,
                          "route": _controllerRoute.text,
                          "phone": phone,
                          "car": _controllerCar.text,
                          "capacity": _controllerCapacity.text,
                          "time": _selectedTime,
                          "date": dateinput.text,
                          "gate": _selectedGate,
                          "fee": _controllerFee.text,
                        });

                        _controllerRoute.clear();
                        _controllerCar.clear();
                        _controllerCapacity.clear();
                        _controllerFee.clear();
                        print("Trip Added Successfully");
                        Navigator.of(context).pop();
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
