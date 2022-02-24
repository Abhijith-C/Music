import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlayerScreen extends StatefulWidget {
  int? index = 0;
  PlayerScreen({Key? key, this.index}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    List<SongModel> songmodel = [];
    _audioQuery.querySongs().then((value) {
      songmodel = value;
    });
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(child: assetsAudioPlayer.builderCurrent(
            builder: (context, Playing? playing) {
          return FutureBuilder<List<FavoritesEntity>>(
              future: _audioRoom.queryFavorites(
                limit: 50,
                reverse: false,
                sortType: null, //  Null will use the [key] has sort.
              ),
              builder: (context, allFavourite) {
                if (allFavourite.data == null) {
                  return const SizedBox();
                }
                // if (allFavourite.data!.isEmpty) {
                //   return const SizedBox();
                // }
                List<FavoritesEntity> favorites = allFavourite.data!;
                List<Audio> favSongs = [];

                for (var fSongs in favorites) {
                  favSongs.add(Audio.file(fSongs.lastData,
                      metas: Metas(
                          title: fSongs.title,
                          artist: fSongs.artist,
                          id: fSongs.id.toString())));
                }
                bool isFav = false;
                int? key;
                for (var fav in favorites) {
                  if (playing!.playlist.current.metas.title == fav.title) {
                    isFav = true;
                    key = fav.key;
                  }
                }
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
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
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
                        SizedBox(
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
                                      int.parse(
                                          playing.playlist.current.metas.id!),
                                      playing.playlist.currentIndex,
                                      songmodel);
                                },
                                icon: Icon(Icons.playlist_add)),
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
                              onPressed: () async {
                                // _audioRoom.addTo(
                                //   RoomType.FAVORITES,
                                //   songmodel[playing.index]
                                //       .getMap
                                //       .toFavoritesEntity(),
                                //   ignoreDuplicate: false, // Avoid the same song
                                // );
                                // bool isAdded = await _audioRoom.checkIn(
                                //   RoomType.FAVORITES,
                                //   songmodel[playing.index].id,
                                // );
                                // print('$isAdded');
                                if (!isFav) {
                                  _audioRoom.addTo(
                                    RoomType.FAVORITES,
                                    songmodel[playing.index]
                                        .getMap
                                        .toFavoritesEntity(),
                                    ignoreDuplicate:
                                        false, // Avoid the same song
                                  );
                                } else {
                                  _audioRoom.deleteFrom(
                                      RoomType.FAVORITES, key!);
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_outline,
                                size: 18,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        })));
  }
}
