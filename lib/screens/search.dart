import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/controller/player.dart';
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
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          // title: const Text('Search Songs'),
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
                  padding: const EdgeInsets.only(
                      top: 5, left: 20, right: 20, bottom: 15),
                  child: SizedBox(
                    child: ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 28,
                      ),
                      title: TextField(
                        onChanged: (value) {
                          controller.filterList(value);
                          // print(controller.searchSongsList.length);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search Songs...',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(Icons.close),
                    ),
                  )),
              Expanded(child: Obx(
                () {
                  var songs = controller.searchSongsList;
                  return ListView.separated(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      var song = songs[index].metas;
                      var songDetails = controller.searchSongsList[index].metas;
                      return ListTile(
                        onTap: () {
                          play(songs, index);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => PlayerScreen()));
                        },
                        title:
                            Text(song.title!, overflow: TextOverflow.ellipsis),
                        subtitle: Text(song.artist ?? "No Artist"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                controller.addToFav(controller.allSongs[index]);
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
                                false ? Icons.favorite : Icons.favorite_outline,
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
                          id: int.parse(
                              controller.searchSongsList[index].metas.id!),
                          type: ArtworkType.AUDIO,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                  );
                },
              ))
            ],
          ),
        ));
  }
}
