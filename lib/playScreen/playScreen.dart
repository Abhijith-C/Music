import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:newmusic/controller/controller.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'title',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://images.cinemaexpress.com/uploads/user/imagelibrary/2019/6/19/original/tovino-thomas-t.jpg',
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'artist',
                  style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                      color: Colors.grey[500]),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: ProgressBar(
                    progress: Duration(milliseconds: 1000),
                    buffered: Duration(milliseconds: 2000),
                    total: Duration(milliseconds: 5000),
                    onSeek: (duration) {
                      // print('User selected a new time: $duration');
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.playlist_add)),
                    IconButton(
                        onPressed: () {
                          assetsAudioPlayer.previous();
                        },
                        icon: Icon(Icons.skip_previous)),
                    IconButton(
                        onPressed: () {
                          assetsAudioPlayer.playOrPause();
                        },
                        icon: Icon(
                          Icons.play_arrow_rounded,
                        )),
                    IconButton(
                        onPressed: () {
                          assetsAudioPlayer.next();
                        },
                        icon: Icon(Icons.skip_next)),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.favorite_outline,
                          size: 20,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
