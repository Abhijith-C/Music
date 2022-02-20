import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';


import 'package:newmusic/playScreen/playScreen.dart';

import 'package:permission_handler/permission_handler.dart';

import 'homeScreen/homeScreen.dart';

void main() {
  runApp(MyApp());
}

void permission() {
  Permission.storage.request();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    permission();
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 1;
  final screens = [
    PlayerScreen(),
    HomeScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.blue,
        height: 50,
        index: currentIndex,
        //animationDuration: Duration(milliseconds: 200),
        backgroundColor: Colors.white,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
            //print(currentIndex);
          });
        },
      ),
    );
  }
}
