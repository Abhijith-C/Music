import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:newmusic/functioins/player.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controller/controller.dart';

class PlaylistInfo extends StatelessWidget {
  int playlistIndex;
  String title;
  PlaylistInfo({
    Key? key,
    required this.playlistIndex,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: Text(title),
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Colors.grey[200],
            ),
            height: double.infinity,
            width: double.infinity,
            child: GetBuilder<Controller>(
              builder: (playlistItems) {
                var songs = playlistItems.playlist[playlistIndex].playlistSongs;
                List<Audio> playlistSong = [];
                for (var song in songs) {
                  playlistSong.add(Audio.file(song.lastData,
                      metas: Metas(
                          title: song.title,
                          artist: song.artist,
                          id: song.id.toString())));
                }
                return playlistSong.isEmpty
                    ? const Center(child: Text('No Songs Found'))
                    : ListView.builder(
                        itemBuilder: (ctx, index) => Slidable(
                          endActionPane: ActionPane(
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  playlistItems.deleteFromPlaylist(
                                      songs[index].id,
                                      playlistItems
                                          .playlist[playlistIndex].key);
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                            motion: const ScrollMotion(),
                          ),
                          child: ListTile(
                            onTap: () {
                              SongModel? song;
                              for (var item in playlistItems.allSongs) {
                                if (item.title ==
                                    playlistItems.playlist[playlistIndex]
                                        .playlistSongs[index].title) {
                                  song = item;
                                }
                              }
                              playFrom(playlistSong, index);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => PlayerScreen(
                                        songListSelector: song,
                                      )));
                            },
                            title: Text(
                              songs[index].title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(songs[index].artist!),
                            leading: QueryArtworkWidget(
                              id: songs[index].id,
                              type: ArtworkType.AUDIO,
                            ),
                          ),
                        ),
                        itemCount: songs.length,
                      );
              },
            )));
  }
}
