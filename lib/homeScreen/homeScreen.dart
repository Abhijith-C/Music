import 'package:flutter/material.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/playScreen/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
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
        title: Text('Music Player'),
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
          builder: (context, item) {
            if (item.data == null)
              return Center(child: const CircularProgressIndicator());

            if (item.data!.isEmpty) return const Text("Nothing found!");

            List<SongModel> songmodel = item.data!;

            List<Audio> songs = [];

            for (var song in songmodel) {
              songs.add(Audio.file(song.uri.toString(),
                  metas: Metas(
                      title: song.title,
                      artist: song.artist,
                      id: song.id.toString())));
            }

            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
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
                    title: Text(item.data![index].title),
                    subtitle: Text(item.data![index].artist ?? "No Artist"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.add,
                        ),
                      ],
                    ),
                    leading: QueryArtworkWidget(
                      //nullArtworkWidget: Icon(Icons.music_note),
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
