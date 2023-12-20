import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';

class tracking extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final String tripKey;
  const tracking({Key? key, required this.tripData, required this.tripKey})
      : super(key: key);

  @override
  State<tracking> createState() => _trackingState();
}

class _trackingState extends State<tracking> {
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  child: textButtons("Start"),
                  onPressed: () async {
                    DatabaseReference databaseReference =
                        FirebaseDatabase.instance.ref();
                    await databaseReference
                        .child("Requests")
                        .child(widget.tripKey)
                        .update({"reqStatus": "in-service"});

                    print("Started the trip");
                  }),
            ),
          ],
        ));
  }
}
