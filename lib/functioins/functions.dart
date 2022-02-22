import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();

final OnAudioRoom _audioRoom = OnAudioRoom();

void dialogBox(BuildContext context, int id, int inde) {
  List<SongModel> songmodel = [];
  _audioQuery.querySongs().then((value) {
    songmodel = value;
  });
  showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  createPlaylist(ctx);
                },
                child: Text('New Playlist'),
              ),
              SimpleDialogOption(
                  child: SizedBox(
                height: 120,
                width: 200,
                child: FutureBuilder<List<PlaylistEntity>>(
                    future: _audioRoom.queryPlaylists(),
                    builder: (context, item) {
                      //final x = item.data[0].id
                      if (item.data == null || item.data!.isEmpty)
                        return Center(
                          child: Text('Nothing Found'),
                        );

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: item.data!.length,
                        itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () async {
                              _audioRoom.addTo(RoomType.PLAYLIST,
                                  songmodel[inde].getMap.toSongEntity(),
                                  playlistKey: item.data![index].key,
                                  ignoreDuplicate: false);
                              Navigator.pop(ctx);
                            },
                            child: Text(item.data![index].playlistName)),
                        separatorBuilder: (ctx, index) => SizedBox(
                          height: 18,
                        ),
                      );
                    }),
              ))
            ],
          ));
}

void createPlaylist(BuildContext ctx) {
  final playlistNameController = TextEditingController();
  showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (ctx1) => AlertDialog(
            content: TextField(
                controller: playlistNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  //filled: true,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  hintText: 'Playlist Name',
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    createNewPlaylist(playlistNameController.text);
                    Navigator.pop(ctx);
                    // dialogBox(context);
                  },
                  child: Text('Ok'))
            ],
          ));
}

void createPlaylistFrom(BuildContext ctx, VoidCallback refresh) {
  final playlistNameController = TextEditingController();
  showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (ctx1) => AlertDialog(
            content: TextField(
                controller: playlistNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  //filled: true,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  hintText: 'Playlist Name',
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    createNewPlaylist(playlistNameController.text);
                    refresh();
                    Navigator.pop(ctx);
                    // dialogBox(context);
                  },
                  child: Text('Ok'))
            ],
          ));
}

void createNewPlaylist(String name) {
  final x = _audioRoom.createPlaylist(name);
  print(x);
}
