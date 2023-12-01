import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'MyWidgets.dart';

class TripsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseReference tripsReference =
        FirebaseDatabase.instance.ref().child('ToCollege');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: iconBack(context),
        title: textPageTitle("Trips"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: tripsReference.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic>? trips =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

            // List<MapEntry<String, dynamic>> tripList = trips?.entries.map<MapEntry<String, dynamic>>((entry) {
            //   return MapEntry<String, dynamic>(entry.key.toString(), entry.value);
            // }).toList() ?? [];
            List<MapEntry> tripList = trips?.entries.toList() ?? [];

            return ListView.builder(
              itemCount: tripList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Container(
                        color: Colors.white70,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.directions),
                              title: Text(
                                  "Direction: ${tripList[index].value["direction"]}"),
                              subtitle: Text(
                                  "Route: ${tripList[index].value["route"]}"),
                            ),
                            ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text(
                                  "Time: ${tripList[index].value["time"]}"),
                              subtitle: Text(
                                  "Waiting Time: ${tripList[index].value["waiting"]}"),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(children: [
                          ListTile(
                            leading: Icon(Icons.person),
                            title:
                                Text("Name: ${tripList[index].value["name"]}"),
                            subtitle: Text(
                                "Phone: ${tripList[index].value["phone"]}"),
                          ),
                          ListTile(
                            leading: Icon(Icons.car_rental),
                            title:
                            Text("Car: ${tripList[index].value["car"]}"),
                            subtitle:  Text(
                                "Capacity: ${tripList[index].value["capacity"]}"),
                          ),
                        ]),
                      ),
                      Container(
                        color: Colors.white70,
                        child: Column(
                          children: [

                            ListTile(
                              leading: Icon(Icons.attach_money),
                              title:
                                  Text("Fees: ${tripList[index].value["fee"]}"),
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
                            DatabaseReference tripToDeleteReference =
                            FirebaseDatabase.instance
                                .ref()
                                .child('ToCollege')
                                .child(tripList[index].key!);
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
    );
  }
}
