// ignore_for_file: implementation_imports

import 'package:assets_audio_player/src/builders/player_builders_ext.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:newmusic/functioins/player.dart';
import 'package:newmusic/screens/favourite.dart';
import 'package:newmusic/screens/playlists.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:permission_handler/permission_handler.dart';
import 'screens/homeScreen.dart';

void main() async {
  await OnAudioRoom().initRoom();
  runApp(const MyApp());
  permission();
}

void permission() {
  Permission.storage.request();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Home(),
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
    Playlists(),
  ];
  Color blueColor = Colors.blue;
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
          backgroundColor: Colors.grey.shade300,
          items: const <Widget>[
            Icon(Icons.favorite_outline, size: 30),
            Icon(Icons.home_outlined, size: 30),
            Icon(Icons.list, size: 30),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        bottomSheet:
            assetsAudioPlayer.builderCurrent(builder: (context, playing) {
          final metas = playing.playlist.current.metas;
          return ListTile(
                  leading: QueryArtworkWidget(
                    artworkBorder: BorderRadius.circular(12),
                    artworkFit: BoxFit.cover,
                    id: int.parse(playing.playlist.current.metas.id!),
                    type: ArtworkType.AUDIO,
                  ),
                  title: Text(metas.title!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis)),
                  subtitle: Text(metas.artist!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            assetsAudioPlayer.previous();
                          },
                          icon: const Icon(Icons.skip_previous)),
                      IconButton(onPressed: () {
                        assetsAudioPlayer.playOrPause();
                      }, icon: assetsAudioPlayer.builderIsPlaying(
                          builder: (ctx, isPlaying) {
                        return isPlaying
                            ? Icon(
                                Icons.pause,
                                color: blueColor,
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: blueColor,
                              );
                      })),
                      IconButton(
                          onPressed: () {
                            assetsAudioPlayer.next();
                          },
                          icon: const Icon(Icons.skip_next)),
                    ],
                  ),
                );
        }));
  }
}
