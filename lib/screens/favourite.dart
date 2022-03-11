import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/controller/player.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

class Favourite extends StatelessWidget {
  final Controller controller = Get.put(Controller());

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
            child: Obx(() {
              if (controller.favorites == null || controller.favorites.isEmpty)
                return Center(
                  child: Text('Nothing Found'),
                );

              return ListView.separated(
                  itemBuilder: (ctx, index) {
                    var favSongs = controller.favSongs[index].metas;
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (context) async {
                            _audioRoom.deleteFrom(RoomType.FAVORITES,
                                controller.favorites[index].key);

                            // bool isAdded = await _audioRoom.checkIn(
                            //   RoomType.FAVORITES,
                            //   favorites[index].key,
                            // );
                            // print('$isAdded');
                            controller.getFavorites();
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ]),
                      child: ListTile(
                        onTap: () {
                          play(controller.favSongs, index);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => PlayerScreen()));
                        },
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          favSongs.title!,
                        ),
                        leading: QueryArtworkWidget(
                          id: int.parse(favSongs.id!),
                          type: ArtworkType.AUDIO,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) => Divider(),
                  itemCount: controller.favSongs.length);
            })));
  }
}
