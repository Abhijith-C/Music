import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:newmusic/favourite/favourite.dart';

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
      debugShowCheckedModeBanner: false,
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
    Favourite(),
    // PlayerScreen(),
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
        color: Colors.grey.shade200,
        //animationDuration: Duration(milliseconds: 200),
        backgroundColor: Colors.grey.shade300,
        items: const <Widget>[
          Icon(Icons.favorite, size: 30),
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
