import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'location_home.dart';

class AddLocation extends StatefulWidget {
  Position userLocation;
  AddLocation(this.userLocation);

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  TextEditingController latitudeController;
  TextEditingController longitudeController;
  TextEditingController nameController;


  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    latitudeController =
        TextEditingController(text: widget.userLocation.latitude.toString());
    longitudeController =
        TextEditingController(text: widget.userLocation.longitude.toString());
    nameController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isSaving,
        opacity: 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: latitudeController,
            ),
            TextField(
              controller: longitudeController,
            ),
            TextField(
              controller: nameController,
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  isSaving = true;
                });
                _addLocation(nameController.text, widget.userLocation.latitude, widget.userLocation.longitude);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));

              },
              child: Text("Add Location"),
            )
          ],
        ),
      ),
    );
  }

  _addLocation(String name, double latitude, double longitude) async {
    String url = "http://192.168.137.1/meler/addlocation.php";
    var response = await http.post(url,
        body: {"name": name, "longitude": longitude.toString(), "latitude": latitude.toString()});
    if(response.statusCode == 200)
      {
        setState(() {
          isSaving = false;
        });

        //navigate to main page

      }
    print(response.body);
    print("Status Code ${response.statusCode}");
  }
}
