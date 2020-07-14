import 'package:QReaderApp/src/pages/home_page.dart';
import 'package:QReaderApp/src/pages/map_page.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'mapa' : (BuildContext context) => MapPage(),
      },
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 0, 100, 1.0)
      ),
    );
  }
}