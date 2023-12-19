import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';
import 'MyWidgets.dart';

class FromCollegeTrips extends StatelessWidget {
  const FromCollegeTrips({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseReference tripsReference =
        FirebaseDatabase.instance.ref().child("FromCollege");

    return StreamBuilder(
      stream: tripsReference.orderByChild("driverID").equalTo(userID).onValue,
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
                            title: Text(
                                "${tripList[index].value["direction"]} - ${tripList[index].value["gate"]}"),
                            subtitle: Text(
                                "Route: ${tripList[index].value["route"]}"),
                          ),
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title:
                                Text("Time: ${tripList[index].value["time"]}"),
                            subtitle:
                                Text("Date: ${tripList[index].value["date"]}"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(children: [
                        ListTile(
                          leading: const Icon(Icons.car_rental),
                          title: Text("Car: ${tripList[index].value["car"]}"),
                          subtitle: Text(
                              "Capacity: ${tripList[index].value["capacity"]}"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text("Name: ${tripList[index].value["name"]}"),
                          subtitle:
                              Text("Phone: ${tripList[index].value["phone"]}"),
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
                                Text("Fees: ${tripList[index].value["fee"]}"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent),
                        ),
                        onPressed: () {
                          DatabaseReference tripToDeleteReference =
                              FirebaseDatabase.instance
                                  .ref()
                                  .child('FromCollege')
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
    );
  }
}
