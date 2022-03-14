import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/controller/player.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  final Controller controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: TextField(
              onChanged: (value) {
                controller.filterList(value);
              },
              decoration: const InputDecoration(
                hintText: 'Search Songs...',
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
        ),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            color: Colors.grey[200],
          ),
          height: double.infinity,
          width: double.infinity,
          child: Obx(
          () {
              var songs = controller.searchSongsList;
              return ListView.separated(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  var song = songs[index].metas;
                  return ListTile(
                    onTap: () {
                      play(songs[index]);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => PlayerScreen()));
                    },
                    title: Text(song.title!, overflow: TextOverflow.ellipsis),
                    subtitle: Text(song.artist ?? "No Artist"),
                    trailing: IconButton(
                      onPressed: () {
                        dialogBox(
                          context,
                          int.parse(song.id!),
                          index,
                          controller.searchSongsList[index]
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
                    leading: QueryArtworkWidget(
                      //nullArtworkWidget: Icon(Icons.music_note),
                      id: int.parse(
                          controller.searchSongsList[index].metas.id!),
                      type: ArtworkType.AUDIO,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              );
            },
          ),
        ));
  }
}
