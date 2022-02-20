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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text('Music Player'),
      ),
      body: FutureBuilder<List<SongModel>>(
        // Default values:
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          // Loading content
          if (item.data == null) return const CircularProgressIndicator();

          // When you try "query" without asking for [READ] or [Library] permission
          // the plugin will return a [Empty] list.
          if (item.data!.isEmpty) return const Text("Nothing found!");

          // You can use [item.data!] direct or you can create a:
          // List<SongModel> songs = item.data!;

          List<SongModel> songmodel = item.data!;

          List<Audio> songs = [];

          for (var song in songmodel) {
            songs.add(Audio.file(song.uri.toString(),
                metas: Metas(title: song.title, artist: song.artist)));
          }

          return ListView.builder(
            itemCount: item.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTile(
                  onTap: () {
                    play(songs, index);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => PlayerScreen()));
                  },
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  // This Widget will query/load image. Just add the id and type.
                  // You can use/create your own widget/method using [queryArtwork].
                  leading: QueryArtworkWidget(
                    nullArtworkWidget: Icon(Icons.music_note),
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
