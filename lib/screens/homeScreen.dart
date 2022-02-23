import 'package:flutter/material.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioRoom _audioRoom = OnAudioRoom();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.settings_outlined))
          ],
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: const Text('Music Player'),
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            color: Colors.grey[200],
          ),
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, allSongs) {
                if (allSongs.data == null)
                  return Center(child: const CircularProgressIndicator());

                if (allSongs.data!.isEmpty) return const Text("Nothing found!");

                List<SongModel> songmodel = allSongs.data!;

                List<Audio> songs = [];

                for (var song in songmodel) {
                  songs.add(Audio.file(song.uri.toString(),
                      metas: Metas(
                          title: song.title,
                          artist: song.artist,
                          id: song.id.toString())));
                }

                return FutureBuilder<List<FavoritesEntity>>(
                  future: _audioRoom.queryFavorites(
                    limit: 50,
                    reverse: false,
                    sortType: null, //  Null will use the [key] has sort.
                  ),
                  builder: (context, allFavourite) {
                    if (allFavourite.data == null) {
                      return const SizedBox();
                    }
                    // if (allFavourite.data!.isEmpty) {
                    //   return const SizedBox();
                    // }
                    List<FavoritesEntity> favorites = allFavourite.data!;
                    List<Audio> favSongs = [];

                    for (var fSongs in favorites) {
                      favSongs.add(Audio.file(fSongs.lastData,
                          metas: Metas(
                              title: fSongs.title,
                              artist: fSongs.artist,
                              id: fSongs.id.toString())));
                    }
                    return ListView.builder(
                      itemCount: allSongs.data!.length,
                      itemBuilder: (context, index) {
                        bool isFav = false;
                        int? key;
                        for (var fav in favorites) {
                          if (songs[index].metas.title == fav.title) {
                            isFav = true;
                            key = fav.key;
                          }
                        }
                        // int key = 0;
                        // for (var ff in favorites) {
                        //   if (songs[index].metas.id == ff.) {
                        //     isFav = true;
                        //     key = ff.key;
                        //   }
                        // }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListTile(
                            onTap: () {
                              play(songs, index);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => PlayerScreen(
                                        index: index,
                                      )));
                            },
                            title: Text(allSongs.data![index].title),
                            subtitle: Text(
                                allSongs.data![index].artist ?? "No Artist"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    // print(isFav);
                                    if (!isFav) {
                                      _audioRoom.addTo(
                                        RoomType
                                            .FAVORITES, // Specify the room type
                                        songmodel[index]
                                            .getMap
                                            .toFavoritesEntity(),
                                        ignoreDuplicate:
                                            false, // Avoid the same song
                                      );
                                    } else {
                                      _audioRoom.deleteFrom(
                                          RoomType.FAVORITES, key!);
                                    }
                                    setState(() {});
                                    // bool isAdded = await _audioRoom.checkIn(
                                    //   RoomType.FAVORITES,
                                    //   songmodel[index].id,
                                    // );
                                    // print('...................$isAdded');
                                  },
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    size: 18,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    dialogBox(
                                        context,
                                        int.parse(songs[index].metas.id!),
                                        index);
                                  },
                                  icon: Icon(
                                    Icons.add,
                                  ),
                                )
                              ],
                            ),
                            leading: QueryArtworkWidget(
                              //nullArtworkWidget: Icon(Icons.music_note),
                              id: allSongs.data![index].id,
                              type: ArtworkType.AUDIO,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
        ));
  }
}
