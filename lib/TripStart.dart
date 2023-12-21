import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';

class TripStart extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final String tripKey;
  const TripStart({Key? key, required this.tripData, required this.tripKey})
      : super(key: key);

  @override
  State<TripStart> createState() => _TripStartState();
}

class _TripStartState extends State<TripStart> {
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
                      child: tripCardTrack(
                          "${widget.tripData["direction"]} - ${widget.tripData["gate"]}",
                          "${widget.tripData["route"]}",
                          "${widget.tripData["time"]}",
                          "${widget.tripData["date"]}",
                          "${widget.tripData["car"]}",
                          "${widget.tripData["capacity"]}",
                          "${widget.tripData["driver"]}",
                          "${widget.tripData["phone"]}",
                          "${widget.tripData["fee"]}"),
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
                  child: textButtons("Start Trip"),
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
