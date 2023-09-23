// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import './random_words.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      theme: ThemeData(primaryColor: Colors.cyan),
      home: RandomWords()
    );
  } //build
} //myapp class


