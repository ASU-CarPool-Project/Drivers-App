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
                      child: tripCardWithoutMethod(
                        "${widget.tripData["direction"]} - ${widget.tripData["gate"]}",
                        "${widget.tripData["route"]}",
                        "${widget.tripData["time"]}",
                        "${widget.tripData["date"]}",
                        "${widget.tripData["car"]}",
                        "${widget.tripData["capacity"]}",
                        "${widget.tripData["driver"]}",
                        "${widget.tripData["phone"]}",
                        "${widget.tripData["fee"]}",
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
                        content: const Text("Did you receive your payment?"),
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
          title: const Text("Success"),
          content: const Text("The trip was successful!"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                Navigator.of(context).pop(); // Close the original dialog
              },
              child: const Text("OK"),
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
              title: const Text("Report Issues"),
              content: TextField(
                onChanged: (text) {
                  setState(() {
                    issuesText = text;
                  });
                },
                decoration:
                    const InputDecoration(labelText: "Describe the issues"),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the issues dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle sending issues to the database
                    _sendIssuesToDatabase(issuesText);

                    Navigator.of(context).pop(); // Close the issues dialog
                    Navigator.of(context).pop(); // Close the original dialog
                  },
                  child: const Text("Send"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _sendIssuesToDatabase(String issuesText) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference
        .child("Requests")
        .child(widget.tripKey)
        .update({"complain": "issue: $issuesText"});
    print("Issues sent to the database: $issuesText");
  }
}
