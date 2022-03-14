import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/song_entity.dart';
import 'package:on_audio_room/on_audio_room.dart';

import '../functioins/functions.dart';

class PlayerScreen extends StatelessWidget {
  SongModel? songListSelector;
  PlayerScreen({Key? key, this.songListSelector}) : super(key: key);
  final Controller controller = Get.put(Controller());
  Color blueColor = Colors.blue;
// ...............................................

  @override
  Widget build(BuildContext context) {
    // if (songListSelector == null) {
    //   songListSelector = controller.allSongs;
    // } else {}
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(child: assetsAudioPlayer.builderCurrent(
            builder: (context, Playing? playing) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
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
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 250,
                      width: 250,
                      child: QueryArtworkWidget(
                        artworkBorder: BorderRadius.circular(12),
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
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    assetsAudioPlayer.builderRealtimePlayingInfos(
                        builder: (context, RealtimePlayingInfos? infos) {
                      if (infos == null) {
                        return const SizedBox();
                      }

                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ProgressBar(
                            timeLabelTextStyle:
                                TextStyle(color: Colors.grey[700]),
                            timeLabelType: TimeLabelType.remainingTime,
                            baseBarColor: Colors.grey[300],
                            progressBarColor: Colors.grey[500],
                            thumbColor: Colors.grey[700],
                            barHeight: 2,
                            thumbRadius: 5,
                            progress: infos.currentPosition,
                            total: infos.duration,
                            onSeek: (duration) {
                              assetsAudioPlayer.seek(duration);
                            },
                          ));
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              dialogBox(
                                  context,
                                  int.parse(playing.playlist.current.metas.id!),
                                  playing.playlist.currentIndex,
                                  playing.playlist.current);
                            },
                            icon: const Icon(Icons.playlist_add)),
                        IconButton(
                            onPressed: () {
                              assetsAudioPlayer.previous();
                            },
                            icon: const Icon(Icons.skip_previous)),
                        assetsAudioPlayer.builderIsPlaying(
                            builder: (context, isPlaying) {
                          return IconButton(
                              onPressed: () {
                                assetsAudioPlayer.playOrPause();
                              },
                              icon: isPlaying
                                  ? Icon(
                                      Icons.pause,
                                      color: blueColor,
                                    )
                                  : Icon(
                                      Icons.play_arrow,
                                      color: blueColor,
                                    ));
                        }),
                        IconButton(
                            onPressed: () {
                              assetsAudioPlayer.next();
                            },
                            icon: const Icon(Icons.skip_next)),
                        GetBuilder<Controller>(
                          builder: (controll) {
                            bool isFav = false;
                            int? key;
                            for (var favSong in controll.favorites) {
                              if (playing.playlist.current.metas.title ==
                                  favSong.title) {
                                isFav = true;
                                key = favSong.key;
                              }
                            }
                            return IconButton(
                              onPressed: () {
                                if (isFav) {
                                  controll.deleteFav(key);
                                } else {
                                  if (songListSelector == null) {
                                    controll.addToFav(
                                        controll.allSongs[playing.index]);
                                  } else {
                                    controll.addToFav(songListSelector!);
                                  }
                                  // controll.addToFav(
                                  //     controll.allSongs[playing.index]);
                                }
                              },
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_outline,
                                size: 18,
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        })));
  }
}
