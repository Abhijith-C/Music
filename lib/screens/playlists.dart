import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Playlist extends StatefulWidget {
  Playlist({Key? key}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
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
          title: Text('Playlist'),
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Colors.grey[200],
            ),
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder<List<PlaylistModel>>(
                future: _audioQuery.queryPlaylists(),
                builder: (context, item) {
                  if (item.data == null)
                    return Center(
                      child: Text('Nothing Found'),
                    );

                  return ListView.separated(
                      itemBuilder: (ctx, index) => Slidable(
                            endActionPane: ActionPane(
                              children: [
                                SlidableAction(
                                  onPressed: (context) {},
                                  backgroundColor: Colors.green.shade400,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      _audioQuery
                                          .removePlaylist(item.data![index].id);
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
                              onTap: ()  {
                                //print(item.data![index].dateAdded);
                                // final x = await _audioQuery.queryAudiosFrom(
                                //     AudiosFromType.PLAYLIST,
                                //     item.data![index].playlist);
                                // print(x);
                              },
                              contentPadding: EdgeInsets.only(left: 20),
                              title: Text(
                                item.data![index].playlist,
                              ),
                              leading: Icon(Icons.music_note),
                            ),
                          ),
                      separatorBuilder: (ctx, index) => Divider(),
                      itemCount: item.data!.length);
                })));
  }
}
