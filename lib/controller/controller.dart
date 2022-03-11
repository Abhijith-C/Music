import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();
final OnAudioRoom _audioRoom = OnAudioRoom();

class Controller extends GetxController {
// ......................................................
  RxList<SongModel> allSongs = <SongModel>[].obs;
  RxList<Audio> songs = <Audio>[].obs;
  RxList<FavoritesEntity> favorites = <FavoritesEntity>[].obs;
  RxList<Audio> favSongs = <Audio>[].obs;

  RxList<Audio> searchSongsList = <Audio>[].obs;
  // List<Audio> searchSongs = <Audio>[].obs;

// .................................................

void fetchSongs() async {
    allSongs.value = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    for (var song in allSongs) {
      songs.add(Audio.file(song.uri.toString(),
          metas: Metas(
              title: song.title, artist: song.artist, id: song.id.toString())));
    }
  }

  void addToFav(SongModel entity) {
    _audioRoom.addTo(
        RoomType.FAVORITES, // Specify the room type
        entity.getMap.toFavoritesEntity(),
        ignoreDuplicate: true); // Avoid the same song
    getFavorites();
  }

  void deleteFav(var key) {
    _audioRoom.deleteFrom(RoomType.FAVORITES, key);
  }

  void getFavorites() async {
    favSongs.clear();
    favorites.value = await _audioRoom.queryFavorites();
    for (var songs in favorites) {
      favSongs.add(Audio.file(songs.lastData,
          metas: Metas(
              title: songs.title,
              artist: songs.artist,
              id: songs.id.toString())));
    }
  }

  filterList(String search) async {
    if (search.isEmpty) {
      searchSongsList = songs;
    } else {
      searchSongsList.value = songs
          .where((song) => song.metas.title!.toLowerCase().contains(search))
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchSongs();
    getFavorites();
    searchSongsList = songs;
  }
}
