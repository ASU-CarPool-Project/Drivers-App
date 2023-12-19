import 'package:asu_carpool_driver/FromCollegeTrips.dart';
import 'package:asu_carpool_driver/ToCollegeTrips.dart';
import 'package:flutter/material.dart';
import 'MyWidgets.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorsPrimary,
          leading: iconBack(context),
          title: textPageTitle("Trips"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        IconData(0xe559,
                            fontFamily: 'MaterialIcons',
                            matchTextDirection: true),
                        color: Colors.white),
                    Text(
                      'To Faculty',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Tab(
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconData(0xe318,
                          fontFamily: 'MaterialIcons',
                          matchTextDirection: true),
                      color: Colors.white,
                    ),
                    Text(
                      'From Faculty',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ToCollegeTrips(),
            FromCollegeTrips(),
          ],
        ),
      ),
    );
  }
}
