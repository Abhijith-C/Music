import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();

void dialogBox(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  createPlaylist(ctx);
                },
                child: Text('New Playlist'),
              ),
              SimpleDialogOption(
                child: Text('Melody'),
              ),
            ],
          ));
}

void createPlaylist(BuildContext ctx) {
  final playlistNameController = TextEditingController();
  showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (ctx1) => AlertDialog(
            //title: Text('Playlist Name'),
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
                    //test();
                    Navigator.pop(ctx);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    createNewPlaylist(playlistNameController.text);
                    //print(playlistNameController.text);
                    Navigator.pop(ctx);
                  },
                  child: Text('Ok'))
            ],
          ));
}

void createNewPlaylist(String name) {
  _audioQuery.createPlaylist(name);
}

//List<String> playlistName = [];
// Future<List<String>> playlist() async {
//   List<String> playlistName = [];
//   final getPlaylist = await _audioQuery.queryPlaylists();
//   for (var playlists in getPlaylist) {
//     playlistName.add(playlists.playlist);
//   }
//   return playlistName;
// }

