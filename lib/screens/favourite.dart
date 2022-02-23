import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Favourite extends StatefulWidget {
  Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    final OnAudioQuery _audioQuery = OnAudioQuery();
    final OnAudioRoom _audioRoom = OnAudioRoom();

    //return Container();
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: Text('Favourite'),
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Colors.grey[200],
            ),
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder<List<FavoritesEntity>>(
                future: _audioRoom.queryFavorites(
                 // limit: 50,
                  reverse: false,
                 // sortType: null, 
                ),
                builder: (context, item) {
                  if (item.data == null || item.data!.isEmpty)
                    return Center(
                      child: Text('Nothing Found'),
                    );
                  List<FavoritesEntity> favorites = item.data!;
                  List<Audio> favSongs = [];
                  for (var songs in favorites) {
                    favSongs.add(Audio.file(songs.lastData,
                        metas: Metas(
                            title: songs.title,
                            artist: songs.artist,
                            id: songs.id.toString())));
                  }
                  return ListView.separated(
                      itemBuilder: (ctx, index) => Slidable(
                            endActionPane:
                                ActionPane(motion: ScrollMotion(), children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  setState(() {
                                    _audioRoom.deleteFrom(RoomType.FAVORITES,
                                        favorites[index].key);
                                  });
                                  // bool isAdded = await _audioRoom.checkIn(
                                  //   RoomType.FAVORITES,
                                  //   favorites[index].key,
                                  // );
                                  // print('$isAdded');
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ]),
                            child: ListTile(
                              onTap: () {
                                play(favSongs, index);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => PlayerScreen()));
                              },
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20),
                              title: Text(
                                favorites[index].title,
                              ),
                              leading: QueryArtworkWidget(
                                id: favorites[index].id,
                                type: ArtworkType.AUDIO,
                              ),
                            ),
                          ),
                      separatorBuilder: (ctx, index) => Divider(),
                      itemCount: item.data!.length);
                })));
  }
}
