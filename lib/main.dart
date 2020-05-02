import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thongkehanghoa/widget/afternoonSession.dart';
import 'package:thongkehanghoa/widget/morningSession.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Thongkehanghoa',
        showSemanticsDebugger: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FlashScreen());
  }
}

class FlashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   getCurrentPage(context);
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  Future getCurrentPage(context) async{
    final share = await SharedPreferences.getInstance();
    final bol = share.getBool("CR")??false;
    if(bol) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AfternoonSession()));
    }else{
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }
}
