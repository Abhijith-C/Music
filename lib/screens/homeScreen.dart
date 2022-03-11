import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/controller/player.dart';
import 'package:newmusic/functioins/functions.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:newmusic/screens/search.dart';
import 'package:newmusic/screens/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:on_audio_room/on_audio_room.dart';

class HomeScreen extends StatelessWidget {
  final Controller controller = Get.put(Controller());

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioRoom _audioRoom = OnAudioRoom();
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
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (ctx) => Settings()));
                },
                icon: Icon(Icons.settings_outlined))
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
          child: Obx(
            () {
              if (controller.songs == null)
                return Center(child: const CircularProgressIndicator());

              if (controller.songs.isEmpty)
                return Center(child: const CircularProgressIndicator());

              return ListView.builder(
                itemCount: controller.songs.length,
                itemBuilder: (context, index) {
                  var song = controller.songs[index];
                  var entity = controller.allSongs[index];
                  bool isFav = false;
                  int? key;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      onTap: () {
                        play(controller.songs, index);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => PlayerScreen()));
                      },
                      title: Text(song.metas.title!,overflow: TextOverflow.ellipsis),
                      subtitle: Text(song.metas.artist ?? "No Artist"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              controller.addToFav(entity);
                              // print(isFav);
                              // if (!isFav) {
                              // _audioRoom.addTo(
                              //     RoomType.FAVORITES, // Specify the room type
                              //     controller.allSongs[index].getMap
                              //         .toFavoritesEntity(),
                              //     ignoreDuplicate: true); // Avoid the same song
                              // controller.getFavorites();

                              //   );
                              // } else {
                              //   _audioRoom.deleteFrom(RoomType.FAVORITES, key!);
                              // }

                              // bool isAdded = await _audioRoom.checkIn(
                              //   RoomType.FAVORITES,
                              //   songmodel[index].id,
                              // );
                              // print('...................$isAdded');
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_outline,
                              size: 18,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     dialogBox(
                          //         context,
                          //         int.parse(songs.metas.id!),
                          //         index,
                          //         songmodel);
                          //   },
                          //   icon: Icon(
                          //     Icons.add,
                          //   ),
                          // )
                        ],
                      ),
                      leading: QueryArtworkWidget(
                        //nullArtworkWidget: Icon(Icons.music_note),
                        id: int.parse(controller.songs[index].metas.id!),
                        type: ArtworkType.AUDIO,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
