import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TripsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseReference tripsReference =
        FirebaseDatabase.instance.ref().child('trips');

    return Scaffold(
      appBar: AppBar(
        title: Text('Trips'),
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
                  child: Column(
                    children: [
                      Text("Route: ${tripList[index].value["direction"]}"),
                      Text("Route: ${tripList[index].value["route"]}"),
                      Text("Route: ${tripList[index].value["name"]}"),
                      Text("Route: ${tripList[index].value["car"]}"),
                      Text("Route: ${tripList[index].value["capacity"]}"),
                      Text("Route: ${tripList[index].value["fee"]}"),
                      ElevatedButton(
                          onPressed: () {
                            DatabaseReference tripToDeleteReference =
                                FirebaseDatabase.instance
                                    .ref()
                                    .child('trips')
                                    .child(tripList[index].key!);
                            tripToDeleteReference.remove().then((_) {
                              print("Trip deleted successfully");
                            }).catchError((error) {
                              print("Failed to delete trip: $error");
                            });
                          },
                          child: Text("Delete"))
                    ],
                  ),
                )
                    // ListTile(
                    //   title: Text("Route: ${tripList[index].value["route"]}"),
                    //   subtitle: Text("Driver: ${tripList[index].value["name"]}"),
                    //   trailing: IconButton(
                    //     icon: Icon(Icons.delete),
                    //     onPressed: () {
                    //       // Delete the corresponding trip when the button is pressed
                    //       DatabaseReference tripToDeleteReference =
                    //       FirebaseDatabase.instance.reference().child('trips').child(tripList[index].key!);
                    //       tripToDeleteReference.remove().then((_) {
                    //         print("Trip deleted successfully");
                    //       }).catchError((error) {
                    //         print("Failed to delete trip: $error");
                    //       });
                    //     },
                    //   ),
                    // ),
                    );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
