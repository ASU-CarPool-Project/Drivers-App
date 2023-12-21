import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home.dart';
import 'MyWidgets.dart';

class ToCollegeTrips extends StatelessWidget {
  const ToCollegeTrips({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseReference tripsReference =
        FirebaseDatabase.instance.ref().child("ToCollege");

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
              return tripCard(
                tripList[index].value,
                "${tripList[index].value["direction"]} - ${tripList[index].value["gate"]}",
                "${tripList[index].value["route"]}",
                "${tripList[index].value["time"]}",
                "${tripList[index].value["date"]}",
                "${tripList[index].value["car"]}",
                "${tripList[index].value["capacity"]}",
                "${tripList[index].value["driver"]}",
                "${tripList[index].value["phone"]}",
                "${tripList[index].value["fee"]}",
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
