import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:newmusic/controller/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatefulWidget {
  int? index = 0;
  PlayerScreen({Key? key, this.index}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool? isPlaying;
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
          child: assetsAudioPlayer.builderCurrent(
              builder: (context, Playing? playing) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Text(
                        '${playing!.playlist.current.metas.title}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(10),
                    //   child: Image.network(
                    //     'https://images.cinemaexpress.com/uploads/user/imagelibrary/2019/6/19/original/tovino-thomas-t.jpg',
                    //     height: 250,
                    //     width: 250,
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: QueryArtworkWidget(
                        artworkBorder: BorderRadius.circular(12),
                        // artworkWidth: 150,
                        // artworkHeight: 150,
                        artworkFit: BoxFit.cover,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          size: 200,
                        ),
                        id: int.parse(playing.playlist.current.metas.id!),
                        type: ArtworkType.AUDIO,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${playing.playlist.current.metas.artist}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    assetsAudioPlayer.builderRealtimePlayingInfos(
                        builder: (context, RealtimePlayingInfos? infos) {
                      if (infos == null) {
                        return const SizedBox();
                      }
                      //print('infos: $infos');
                      return Padding(
                          padding: const EdgeInsets.symmetric(),
                          child: ProgressBar(
                            progress: infos.currentPosition,
                            total: infos.duration,
                            onSeek: (duration) {
                              assetsAudioPlayer.seek(duration);
                            },
                          ));
                    }),
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
                        assetsAudioPlayer.builderIsPlaying(
                            builder: (context, isPlaying) {
                          return IconButton(
                              onPressed: () {
                                assetsAudioPlayer.playOrPause();
                              },
                              icon: isPlaying
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow));
                        }),
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
            );
          }),
        ));
  }
}
