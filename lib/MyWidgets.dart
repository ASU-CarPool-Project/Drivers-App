import 'package:flutter/material.dart';

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
