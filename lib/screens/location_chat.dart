import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:meler/location_item.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'add_location.dart';

class LocationChat extends StatelessWidget {
  LatLng location;
  Position userPosition;

//  LocationChat({Key key, @required this.location}) : super(key: key);
  LocationChat({Key key, @required this.userPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getLocationChat(userPosition.latitude, userPosition.longitude),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<LocationItem> locationchats = snapshot.data;
          if (locationchats.length > 0) {
            return ListView.builder(
                itemCount: locationchats.length,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (context, position) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          title: Text('${locationchats[position].name} Chat'),
                          subtitle: Text(
                              'Lat: ${locationchats[position].latitude} Lon: ${locationchats[position].longitude}'),
                          onTap: () {
                            // handle your logics to take user to the chat here
                          },
                        ),
                        elevation: 5.0,
                      ),
                    ],
                  );
                });
          } else {
            //no location found
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Didn't Find Your Location?",
                  textAlign: TextAlign.center,
                ),
                FlatButton(
                  child: Text(
                    "ADD LOCATION",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddLocation(userPosition)));
                  },
                )
              ],
            );
          }
        } else {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Getting Available Chats for Lat: ${userPosition.latitude} Lon: ${userPosition.longitude}"),
              CircularProgressIndicator(),
            ],
          ));
        }
      },
    );
  }

  Future<List<LocationItem>> _getLocationChat(
      double latitude, double longitude) async {
    final String url =
        'http://192.168.137.1/meler/location.php?latitude=$latitude&longitude=$longitude';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Iterable jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => LocationItem.fromJson(item)).toList();
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }
}
