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
