import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playlistInfo.dart';

class Playlists extends StatelessWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final OnAudioQuery _audioQuery = OnAudioQuery();

    //return Container();
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: const Text('Playlists'),
          actions: [
            IconButton(
                onPressed: () {
                  createPlaylistFrom(context, () {});
                },
                icon: const Icon(Icons.playlist_add))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Colors.grey[200],
            ),
            height: double.infinity,
            width: double.infinity,
            child: GetBuilder<Controller>(builder: (playlists) {
              if (playlists.playlist.isEmpty) {
                return const Center(
                  child: Text('No Playlist Found'),
                );
              }
              return ListView.separated(
                  itemBuilder: (ctx, index) => Slidable(
                        endActionPane: ActionPane(
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                dialog(context, playlists.playlist[index].key);
                              },
                              backgroundColor: Colors.green.shade400,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                controller.deletePlaylist(
                                    playlists.playlist[index].key);
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
                            //final x = item.data[index].key;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => PlaylistInfo(
                                          title: playlists
                                              .playlist[index].playlistName,
                                          // songs: playlists.playlist[index].playlistSongs,
                                          // playlistKey:
                                          //     playlists.playlist[index].key,
                                          playlistIndex: index,
                                        )));
                          },
                          contentPadding: const EdgeInsets.only(left: 20),
                          title: Text(
                            playlists.playlist[index].playlistName,
                          ),
                          leading: const Icon(Icons.music_note),
                        ),
                      ),
                  separatorBuilder: (ctx, index) => const Divider(),
                  itemCount: playlists.playlist.length);
            })));
  }

  void dialog(BuildContext context, int key) {
    final playlistNameController = TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
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
                      Navigator.pop(ctx1);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      controller.editPlaylist(key, playlistNameController.text);
                      Navigator.pop(ctx1);
                    },
                    child: const Text('Ok'))
              ],
            ));
  }
}
