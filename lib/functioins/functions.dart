import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();

void dialogBox(BuildContext context, int id) {
  showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  createPlaylist(ctx, context);
                },
                child: Text('New Playlist'),
              ),
              SimpleDialogOption(
                  child: SizedBox(
                height: 120,
                width: 200,
                child: FutureBuilder<List<PlaylistModel>>(
                    future: _audioQuery.queryPlaylists(),
                    builder: (context, item) {
                      //final x = item.data[0].id
                      if (item.data == null)
                        return Center(
                          child: Text('Nothing Found'),
                        );

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: item.data!.length,
                        itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () {
                              // print(',,,,,,,,,,,,,${item.data![index].id}');
                              //print(item.data![index].dateAdded);
                              // final x = _audioQuery.addToPlaylist(
                              //     item.data![index].id, id);
                              // print(x);
                              //_audioQuery.queryAudiosFrom();
                            },
                            child: Text(item.data![index].playlist)),
                        separatorBuilder: (ctx, index) => SizedBox(
                          height: 16,
                        ),
                      );
                    }),
              ))
            ],
          ));
}

void createPlaylist(BuildContext ctx, BuildContext context) {
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
                    Navigator.pop(context);
                    // dialogBox(context);
                  },
                  child: Text('Ok'))
            ],
          ));
}

void createNewPlaylist(String name) {
  _audioQuery.createPlaylist(name);
}
