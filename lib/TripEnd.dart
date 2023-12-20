import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';

class TripEnd extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final String tripKey;
  const TripEnd({Key? key, required this.tripData, required this.tripKey})
      : super(key: key);

  @override
  State<TripEnd> createState() => _TripEndState();
}

class _TripEndState extends State<TripEnd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: iconBack(context),
          backgroundColor: colorsPrimary,
          title: textPageTitle("Pickup Request"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Card(
                        color: colorsCards,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Container(
                              color: Colors.white70,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.directions),
                                    title: Text(
                                        "${widget.tripData["direction"]} - ${widget.tripData["gate"]}"),
                                    subtitle: Text(
                                        "Route: ${widget.tripData["route"]}"),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.access_time),
                                    title: Text(
                                        "Time: ${widget.tripData["time"]}"),
                                    subtitle: Text(
                                        "Date: ${widget.tripData["date"]}"),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Column(children: [
                                ListTile(
                                  leading: const Icon(Icons.car_rental),
                                  title: Text("Car: ${widget.tripData["car"]}"),
                                  subtitle: Text(
                                      "Capacity: ${widget.tripData["capacity"]}"),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(
                                      "Driver: ${widget.tripData["driver"]}"),
                                  subtitle: Text(
                                      "Phone: ${widget.tripData["phone"]}"),
                                ),
                              ]),
                            ),
                            Container(
                              color: Colors.white70,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.attach_money),
                                    title:
                                        Text("Fees: ${widget.tripData["fee"]}"),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                  "Don't End the trip until you have arrived to your destination"),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: textButtons("End Trip"),
                onPressed: () async {
                  // DatabaseReference databaseReference =
                  //     FirebaseDatabase.instance.ref();
                  // await databaseReference
                  //     .child("Requests")
                  //     .child(widget.tripKey)
                  //     .update({"reqStatus": "ended"});

                  // Show the custom dialog
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // User can't dismiss the dialog by tapping outside
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Waiting for Payment"),
                        content: Text("Did you receive your payment?"),
                        actions: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _showSuccessDialog(context);
                            },
                            child: textButtons("Yes"),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _showIssuesDialog(context);
                            },
                            child: textButtons("No"),
                          ),
                        ],
                      );
                    },
                  );

                  print("Ended the trip");
                },
              ),
            ),
          ],
        ));
  }

  //////////////////////////////////////////////////////////////////////////////
  /// My Functions

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("The trip was successful!"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                Navigator.of(context).pop(); // Close the original dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showIssuesDialog(BuildContext context) async {
    String issuesText = ""; // Variable to store issues text

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Report Issues"),
              content: TextField(
                onChanged: (text) {
                  setState(() {
                    issuesText = text;
                  });
                },
                decoration: InputDecoration(labelText: "Describe the issues"),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the issues dialog
                  },
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle sending issues to the database
                    _sendIssuesToDatabase(issuesText);

                    Navigator.of(context).pop(); // Close the issues dialog
                    Navigator.of(context).pop(); // Close the original dialog
                  },
                  child: Text("Send"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _sendIssuesToDatabase(String issuesText) async {
    // Add your logic to send the issuesText to the Realtime Database
    // Use the FirebaseDatabase.instance reference and update the appropriate node
    // Example: FirebaseDatabase.instance.ref().child("issues").push().set(issuesText);
    print("Issues sent to the database: $issuesText");
  }
}
