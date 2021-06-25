import 'package:flutter/material.dart';

AppBar MainAppBar(){
  return AppBar(
    // backgroundColor: const Color(0xFFf8fefe),
    backgroundColor: const Color(0xFF305496),
    elevation:3.0,
    centerTitle: true,
    backwardsCompatibility: false,
    title: Text('FlutterShop',style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontFamily: 'Permanent Marker'
    ),),
  );
}
