import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hardwarekeys/hardwarekeys.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _streamSubscription;
  String _lastKeyPressed;

  @override
  void initState() {
    super.initState();
    _streamSubscription = hardwareKeyEvents.listen((HardwareKeyEvent event){
      setState(() {
      _lastKeyPressed = event.type;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: Text('Key Pressed\n$_lastKeyPressed'),
          ),
        ),
      ),
    );
  }
}
