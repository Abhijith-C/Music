import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:on_audio_room/on_audio_room.dart';

final OnAudioRoom _audioRoom = OnAudioRoom();
final Controller controller = Get.put(Controller());
void dialogBox(BuildContext context, int id, int inde, Audio song) {
  showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () {
                  createPlaylist(ctx);
                },
                child: Column(
                  children: const [
                    Text(
                      'Create New Playlist',
                      style: TextStyle(color: Colors.blue),
                    ),
                    Divider()
                  ],
                ),
              ),
              SimpleDialogOption(
                  child: SizedBox(
                height: 120,
                width: 200,
                child: GetBuilder<Controller>(builder: (item) {
                  var ind = item.songs.indexOf(song);
                  if (item.playlist.isEmpty) {
                    return const Center(
                      child: Text('Nothing Found'),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: item.playlist.length,
                    itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () async {
                          _audioRoom.addTo(RoomType.PLAYLIST,
                              item.allSongs[ind].getMap.toSongEntity(),
                              playlistKey: item.playlist[index].key,
                              ignoreDuplicate: false);
                          Navigator.pop(ctx);
                        },
                        child: Text(item.playlist[index].playlistName)),
                    separatorBuilder: (ctx, index) => const SizedBox(
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
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    controller.createPlaylist(playlistNameController.text);
                    // setState(() {});
                    Navigator.pop(ctx);
                    // dialogBox(context);
                  },
                  child: const Text('Ok'))
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
                    controller.createPlaylist(playlistNameController.text);
                    // createNewPlaylist(playlistNameController.text);
                    // refresh();
                    Navigator.pop(ctx);
                    // dialogBox(context);
                  },
                  child: Text('Ok'))
            ],
          ));
}

// void createNewPlaylist(String name) {
//   final x = _audioRoom.createPlaylist(name);
//   print(x);
// }
