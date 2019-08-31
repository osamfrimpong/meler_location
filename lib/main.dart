import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'screens/location_home.dart';


void main() => runApp(MelerMap());

class MelerMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primaryColor: Colors.purple),
    );
  }
}