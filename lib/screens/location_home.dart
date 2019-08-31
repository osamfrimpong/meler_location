import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_settings/app_settings.dart';
import 'location_chat.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Geolocator geolocator = Geolocator();

  Position userLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getStoredLocation().then((location){
      if(location.longitude == 0 || location.latitude == 0)
      {

        _getLocation().then((position) {
          _storeLocation(position.latitude, position.longitude);
          setState(() {
            userLocation = position;
          });

        });
      }
      else{
        setState(() {
          userLocation = Position(longitude: location.longitude,latitude: location.latitude);
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            child: userLocation == null ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    AppSettings.openLocationSettings();
                    _getLocation().then((position) {
                      //store location
                      _storeLocation(position.latitude, position.longitude);
                      setState(() {
                        userLocation = position;
                      });
                    });
                  },
                  color: Colors.purple,
                  child: Text(
                    "Turn on GPS",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ) : LocationChat(userPosition: userLocation)
            ,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.refresh,color: Colors.white,),onPressed: (){
        _getLocation().then((position) {
          //store location
          _storeLocation(position.latitude, position.longitude);
          setState(() {
            userLocation = position;
          });
        });
      },backgroundColor: Colors.purple,),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  _storeLocation(double latitude,double longitude) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('longitude') && prefs.containsKey('latitude')){
      prefs.clear();
    }
    prefs.setDouble('latitude', latitude);
    prefs.setDouble('longitude', longitude);
  }

  Future<LatLng> _getStoredLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude =  prefs.getDouble('latitude') ?? 0.0;
    double longitude =  prefs.getDouble('longitude') ?? 0.0;
    print("Location $longitude and $latitude");
    return LatLng(latitude,longitude);
  }


}


