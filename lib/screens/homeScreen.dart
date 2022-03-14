import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/functioins/player.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:newmusic/screens/search.dart';
import 'package:newmusic/screens/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final Controller controller = Get.put(Controller());
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => SearchPage()));
                },
                icon: const Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => const Settings()));
                },
                icon: const Icon(Icons.settings_outlined))
          ],
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: const Text('Music Player'),
        ),
        body: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Colors.grey[200],
            ),
            height: double.infinity,
            width: double.infinity,
            child: GetBuilder<Controller>(
              init: Controller(),
              builder: (controll) {
                return controll.allSongs.isEmpty ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
                  itemCount: controll.songs.length,
                  itemBuilder: (context, index) {
                    var song = controll.songs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        onTap: () {
                          play(controll.songs[index]);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => PlayerScreen()));
                        },
                        title: Text(song.metas.title!,
                            overflow: TextOverflow.ellipsis),
                        subtitle: Text(song.metas.artist ?? "No Artist"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                dialogBox(
                                    context,
                                    int.parse(
                                        controll.songs[index].metas.id!),
                                    index,controll.songs[index]);
                              },
                              icon: const Icon(
                                Icons.add,
                              ),
                            )
                          ],
                        ),
                        leading: QueryArtworkWidget(
                          //nullArtworkWidget: Icon(Icons.music_note),
                          id: int.parse(controll.songs[index].metas.id!),
                          type: ArtworkType.AUDIO,
                        ),
                      ),
                    );
                  },
                );
              },
            )));
  }
}
