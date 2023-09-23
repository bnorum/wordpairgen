// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import './random_words.dart';
import 'env/env.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:envied/envied.dart';

void main() { runApp(MyApp());}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      theme: ThemeData(primaryColor: Colors.cyan),
      home: RandomWords()
    );
  } //build
} //myapp class


