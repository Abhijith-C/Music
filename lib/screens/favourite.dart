import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';
import 'package:newmusic/controller/player.dart';
import 'package:newmusic/screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favourite extends StatelessWidget {
  Favourite({Key? key}) : super(key: key);
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[100],
          title: const Text('Favourite'),
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
              builder: (controll) {
                return controll.favSongs.isEmpty
                    ? const Center(
                        child: Text('No Favourite Found'),
                      )
                    : ListView.separated(
                        itemBuilder: (ctx, index) {
                          var favSongs = controll.favSongs[index].metas;
                          return Slidable(
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      controll.deleteFav(
                                          controll.favorites[index].key);
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ]),
                            child: ListTile(
                              onTap: () {
                                playFrom(controll.favSongs, index);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => PlayerScreen()));
                              },
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              title: Text(
                                favSongs.title!,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis),
                              ),
                              leading: QueryArtworkWidget(
                                id: int.parse(favSongs.id!),
                                type: ArtworkType.AUDIO,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, index) => const Divider(),
                        itemCount: controll.favSongs.length);
              },
            )));
  }
}
