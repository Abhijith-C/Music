import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:newmusic/screens/favourite.dart';
import 'package:newmusic/screens/playlists.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/homeScreen.dart';

void main() async {
  await OnAudioRoom().initRoom(RoomType.FAVORITES);
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
    HomeScreen(),
    Playlist(),
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
          Icon(Icons.favorite_outline, size: 30),
          Icon(Icons.home_outlined, size: 30),
          Icon(Icons.list, size: 30),
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
