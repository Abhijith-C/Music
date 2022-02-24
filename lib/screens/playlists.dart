import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playlistInfo.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Playlists extends StatefulWidget {
  Playlists({Key? key}) : super(key: key);

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    final OnAudioQuery _audioQuery = OnAudioQuery();

    //return Container();
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: Text('Playlists'),
          actions: [
            IconButton(
                onPressed: () {
                  createPlaylistFrom(context, () {
                    setState(() {
                      
                    });
                  });
                },
                icon: Icon(Icons.playlist_add))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Colors.grey[200],
            ),
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder<List<PlaylistEntity>>(
                future: _audioRoom.queryPlaylists(),
                builder: (context, item) {
                  if (item.data == null || item.data!.isEmpty)
                    return Center(
                      child: const Text('Nothing Found'),
                    );

                  return ListView.separated(
                      itemBuilder: (ctx, index) => Slidable(
                            endActionPane: ActionPane(
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    dialog(context, item.data![index].key);
                                  },
                                  backgroundColor: Colors.green.shade400,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      _audioRoom.deletePlaylist(
                                          item.data![index].key);
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
                                //final x = item.data[index].key;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => PlaylistInfo(
                                              title: item
                                                  .data![index].playlistName,
                                              songs: item
                                                  .data![index].playlistSongs,
                                              playlistKey:
                                                  item.data![index].key,
                                            )));
                                //final x = item.data![index].playlistSongs;
                                // print(x);
                                //list songs in playlist
                                // final x = item.data![index].;
                                // _audioRoom.addAllTo(RoomType.PLAYLIST, )
                                //print(item.data![index].dateAdded);
                                // final x = await _audioQuery.queryAudiosFrom(
                                //     AudiosFromType.PLAYLIST,
                                //     item.data![index].playlist);
                                // print(x);
                              },
                              contentPadding: EdgeInsets.only(left: 20),
                              title: Text(
                                item.data![index].playlistName,
                              ),
                              leading: Icon(Icons.music_note),
                            ),
                          ),
                      separatorBuilder: (ctx, index) => Divider(),
                      itemCount: item.data!.length);
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
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _audioRoom.renamePlaylist(
                            key, playlistNameController.text);
                      });
                      Navigator.pop(ctx1);
                      //createNewPlaylist(playlistNameController.text);

                      // dialogBox(context);
                    },
                    child: Text('Ok'))
              ],
            ));
  }
}
