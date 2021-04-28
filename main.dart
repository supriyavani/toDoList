import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/homepage.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      home: HomePage(),
    );
  }
}



 