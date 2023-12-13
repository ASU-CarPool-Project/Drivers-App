import 'package:flutter/material.dart';
import 'MyWidgets.dart';
import 'package:firebase_database/firebase_database.dart';
import "home.dart";

class requests extends StatefulWidget {
  const requests({Key? key}) : super(key: key);

  @override
  State<requests> createState() => _requestsState();
}

class _requestsState extends State<requests> {
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
                                child: Row(children: [
                                  const Icon(
                                    Icons.pin_drop_sharp,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textPageTitle(
                                            "Route: ${tripList[index].value["route"]}"),
                                        textPageTitle(
                                            "${tripList[index].value["date"]} / ${tripList[index].value["time"]}"),
                                        textPageTitle("Client: $username"),
                                      ])
                                ]))),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textLargeTitle("Searching for trips..."),
                          const CircularProgressIndicator()
                        ]),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
