import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Color? colorsPrimary = Colors.deepOrange[500];
Color? colorsToCollege = Colors.deepOrangeAccent[100];
Color? colorsFromCollege = Colors.deepOrangeAccent[100];
Color? colorsCards = Colors.deepOrangeAccent[100];

Widget textButtons(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    ),
  );
}

Widget textPageTitle(String text) {
  return Text(
    text,
    style: const TextStyle(color: Colors.white),
  );
}

Widget textLargeTitle(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: TextStyle(fontSize: 24, color: colorsPrimary),
    ),
  );
}

Widget textPlace(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

Widget iconBack(BuildContext context) {
  return IconButton(
    icon: const Icon(
      IconData(
        0xe093,
        fontFamily: 'MaterialIcons',
        matchTextDirection: true,
      ),
      color: Colors.white,
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Future<bool?> toastMsg(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 4,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Widget tripCard(
  var currTrip,
  String? route,
  String? district,
  String? time,
  String? date,
  String? car,
  String? capacity,
  String? driver,
  String? phone,
  String? fees,
) {
  return Card(
    color: colorsToCollege,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Container(
          color: Colors.white70,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.directions),
                title: Text(route!),
                subtitle: Text("District: $district"),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text("Time: $time"),
                subtitle: Text("Date: $date"),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.car_rental),
              title: Text("Car: $car"),
              subtitle: Text("Capacity: $capacity"),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Driver: $driver"),
              subtitle: Text("Phone: $phone"),
            ),
          ]),
        ),
        Container(
          color: Colors.white70,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text("Fees: $fees"),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.redAccent),
            ),
            onPressed: () {
              DatabaseReference tripToDeleteReference = FirebaseDatabase
                  .instance
                  .ref()
                  .child('FromCollege')
                  .child(currTrip.key!);
              tripToDeleteReference.remove().then((_) {
                print("Trip deleted successfully");
              }).catchError((error) {
                print("Failed to delete trip: $error");
              });
            },
            child: textButtons("Delete"),
          ),
        )
      ]),
    ),
  );
}

Widget tripCardTrack(
  String? route,
  String? district,
  String? time,
  String? date,
  String? car,
  String? capacity,
  String? driver,
  String? phone,
  String? fees,
) {
  return Card(
    color: colorsToCollege,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Container(
          color: Colors.white70,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.directions),
                title: Text(route!),
                subtitle: Text("District: $district"),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text("Time: $time"),
                subtitle: Text("Date: $date"),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.car_rental),
              title: Text("Car: $car"),
              subtitle: Text("Capacity: $capacity"),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Driver: $driver"),
              subtitle: Text("Phone: $phone"),
            ),
          ]),
        ),
        Container(
          color: Colors.white70,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: Text("Fees: $fees"),
              ),
            ],
          ),
        ),
      ]),
    ),
  );
}
