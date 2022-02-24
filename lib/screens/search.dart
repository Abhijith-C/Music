import 'package:flutter/material.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioRoom _audioRoom = OnAudioRoom();
  String searchTerm = '';
  final searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
                  },
                ),
              ),
              Expanded(
                  child: (searchTerm.isEmpty)
                      ? FutureBuilder<List<SongModel>>(
                          future: _audioQuery.querySongs(
                            sortType: null,
                            orderType: OrderType.ASC_OR_SMALLER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true,
                          ),
                          builder: (context, allSongs) {
                            if (allSongs.data == null)
                              return Center(
                                  child: const CircularProgressIndicator());

                            if (allSongs.data!.isEmpty)
                              return const Text("Nothing found!");

                            List<SongModel> songmodel = allSongs.data!;

                            List<Audio> songs = [];

                            for (var song in songmodel) {
                              songs.add(Audio.file(song.uri.toString(),
                                  metas: Metas(
                                      title: song.title,
                                      artist: song.artist,
                                      id: song.id.toString())));
                            }

                            return ListView.builder(
                              itemCount: allSongs.data!.length,
                              itemBuilder: (context, index) {
                                // int key = 0;
                                // for (var ff in favorites) {
                                //   if (songs[index].metas.id == ff.) {
                                //     isFav = true;
                                //     key = ff.key;
                                //   }
                                // }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ListTile(
                                    onTap: () {
                                      play(songs, index);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => PlayerScreen(
                                                    index: index,
                                                  )));
                                    },
                                    title: Text(allSongs.data![index].title),
                                    subtitle: Text(
                                        allSongs.data![index].artist ??
                                            "No Artist"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        dialogBox(
                                            context,
                                            int.parse(songs[index].metas.id!),
                                            index,
                                            songmodel);
                                      },
                                      icon: Icon(
                                        Icons.add,
                                      ),
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
                          })
                      : FutureBuilder<List<SongModel>>(
                          future: _audioQuery.querySongs(
                            sortType: null,
                            orderType: OrderType.ASC_OR_SMALLER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true,
                          ),
                          builder: (context, allSongs) {
                            if (allSongs.data == null)
                              return Center(
                                  child: const CircularProgressIndicator());

                            if (allSongs.data!.isEmpty)
                              return const Text("Nothing found!");

                            List<SongModel> songmodel = allSongs.data!;

                            List<SongModel> songModelList = songmodel
                                .where((song) => song.title
                                    .toLowerCase()
                                    .contains(searchTerm))
                                .toList();

                            List<Audio> songs = [];

                            for (var song in songModelList) {
                              songs.add(Audio.file(song.uri.toString(),
                                  metas: Metas(
                                      title: song.title,
                                      artist: song.artist,
                                      id: song.id.toString())));
                            }

                            return ListView.builder(
                              itemCount: songs.length,
                              itemBuilder: (context, index) {
                                // bool isFav = false;
                                // int? key;
                                // for (var fav in favorites) {
                                //   if (songs[index].metas.title ==
                                //       fav.title) {
                                //     isFav = true;
                                //     key = fav.key;
                                //   }
                                // }
                                // int key = 0;
                                // for (var ff in favorites) {
                                //   if (songs[index].metas.id == ff.) {
                                //     isFav = true;
                                //     key = ff.key;
                                //   }
                                // }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ListTile(
                                    onTap: () {
                                      play(songs, index);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => PlayerScreen(
                                                    index: index,
                                                    songModel2: songModelList,
                                                  )));
                                    },
                                    title: Text(songs[index].metas.title!),
                                    subtitle: Text(songs[index].metas.artist ??
                                        "No Artist"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        dialogBox(
                                            context,
                                            int.parse(songs[index].metas.id!),
                                            index,
                                            songModelList);
                                      },
                                      icon: Icon(
                                        Icons.add,
                                      ),
                                    ),
                                    leading: QueryArtworkWidget(
                                      //nullArtworkWidget: Icon(Icons.music_note),
                                      id: int.parse(songs[index].metas.id!),
                                      type: ArtworkType.AUDIO,
                                    ),
                                  ),
                                );
                              },
                            );
                          })),
            ],
          ),
        ));
  }
}
