import 'dart:async';

import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'package:firebase_database/firebase_database.dart';
import "home.dart";

String myResponse = "";

class requests extends StatefulWidget {
  const requests({Key? key}) : super(key: key);

  @override
  State<requests> createState() => _requestsState();
}

class _requestsState extends State<requests> {
  Completer<String?> _dialogCompleter = Completer<String?>();

  DatabaseReference tripsReference =
      FirebaseDatabase.instance.ref().child("Requests").child("Pending");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorsPrimary,
        leading: iconBack(context),
        title: textPageTitle("Requests"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: StreamBuilder(
              stream: tripsReference
                  .orderByChild("driverID")
                  .equalTo("$userID")
                  .onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic>? trips =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                  List<MapEntry> tripList = trips?.entries.toList() ?? [];

                  return ListView.builder(
                    itemCount: tripList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          color: Colors.yellow,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.pin_drop_sharp,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textPageTitle(
                                        "Route: ${tripList[index].value["route"]}"),
                                    textPageTitle(
                                        "${tripList[index].value["date"]} / ${tripList[index].value["time"]}"),
                                    textPageTitle(
                                        "Client: ${tripList[index].value["client"]}"),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    _showAcceptDeclineDialog(
                                      tripID: tripList[index].key.toString(),
                                    );

                                    // print(
                                    //     "look here: ${tripList[index].value["reqStatus"]}");

                                    // DatabaseReference tripToAddReference =
                                    //     FirebaseDatabase.instance
                                    //         .ref()
                                    //         .child("Requests")
                                    //         .child("$response");

                                    // Map<dynamic, dynamic>? tripData =
                                    //     tripList[index].value;
                                    // DatabaseReference newTripReference =
                                    //     tripToAddReference.push();
                                    // tripData?.forEach((key, value) {
                                    //   newTripReference.child(key).set(value);
                                    // });

                                    // DatabaseReference tripToDeleteReference =
                                    //     FirebaseDatabase.instance
                                    //         .ref()
                                    //         .child("Requests")
                                    //         .child("Pending")
                                    //         .child(tripList[index].key!);
                                    // tripToDeleteReference.remove().then((_) {
                                    //   print("Trip deleted successfully");
                                    // }).catchError((error) {
                                    //   print("Failed to delete trip: $error");
                                    // });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textLargeTitle("Searching for trips..."),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  /// My Functions

  void _showAcceptDeclineDialog({required String tripID}) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Accept or Decline?"),
          actions: [
            TextButton(
              onPressed: () {
                _updateStatus(tripID, "Accepted");
                Navigator.of(context).pop();
              },
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () {
                _updateStatus(tripID, "Declined");
                Navigator.of(context).pop();
              },
              child: const Text("Decline"),
            ),
          ],
        );
      },
    );

    // Return the Future from the Completer
  }

  void _updateStatus(String tripID, String newStatus) {
    tripsReference.child(tripID).update({"reqStatus": newStatus});
  }
}
