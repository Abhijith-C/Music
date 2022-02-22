import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistInfo extends StatefulWidget {
  int playlistKey;
  List<SongEntity> songs;
  String title;
  PlaylistInfo(
      {Key? key,
      required this.title,
      required this.songs,
      required this.playlistKey})
      : super(key: key);

  @override
  State<PlaylistInfo> createState() => _PlaylistInfoState();
}

class _PlaylistInfoState extends State<PlaylistInfo> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    List<Audio> playlistSong = [];
    for (var song in widget.songs) {
      playlistSong.add(Audio.file(song.lastData,
          metas: Metas(
              title: song.title, artist: song.artist, id: song.id.toString())));
    }
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: Text(widget.title),
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Colors.grey[200],
            ),
            height: double.infinity,
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (ctx, index) => Slidable(
                endActionPane: ActionPane(
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          _audioRoom.deleteFrom(
                              RoomType.PLAYLIST, widget.songs[index].id,
                              playlistKey: widget.playlistKey);
                        });
                      },
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                  motion: ScrollMotion(),
                ),
                child: ListTile(
                  onTap: () {
                    play(playlistSong, index);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => PlayerScreen()));
                  },
                  title: Text(widget.songs[index].title),
                  subtitle: Text(widget.songs[index].artist!),
                  leading: QueryArtworkWidget(
                    id: widget.songs[index].id,
                    type: ArtworkType.AUDIO,
                  ),
                ),
                //itemCount: widget.songs.length,
              ),
              itemCount: widget.songs.length,
            )));
  }
}
