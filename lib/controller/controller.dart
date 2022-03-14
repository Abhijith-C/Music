import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';

final OnAudioQuery _audioQuery = OnAudioQuery();
final OnAudioRoom _audioRoom = OnAudioRoom();

class Controller extends GetxController {
  int homepageIndex = 1;
  bool permissionStatus = false;
  List<Audio> songs = [];
  List<FavoritesEntity> favorites = [];

  List<SongModel> allSongs = [];
  List<Audio> favSongs = [];
  var searchSongsList = <Audio>[].obs;
  List<PlaylistEntity> playlist = [];
  bool notification = true;

// .................................................

  void fetchSongs() async {
    allSongs = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    for (var song in allSongs) {
      songs.add(Audio.file(song.uri.toString(),
          metas: Metas(
              title: song.title, artist: song.artist, id: song.id.toString())));
    }
    update();
  }

  void addToFav(SongModel entity) {
    _audioRoom.addTo(RoomType.FAVORITES, entity.getMap.toFavoritesEntity(),
        ignoreDuplicate: true);
    getFavorites();
    update();
  }

  void deleteFav(var key) {
    _audioRoom.deleteFrom(RoomType.FAVORITES, key);
    getFavorites();
    update();
  }

  void getFavorites() async {
    favSongs.clear();
    favorites = await _audioRoom.queryFavorites();
    for (var songs in favorites) {
      favSongs.add(Audio.file(songs.lastData,
          metas: Metas(
              title: songs.title,
              artist: songs.artist,
              id: songs.id.toString())));
    }
  }

  filterList(String search) {
    if (search.isEmpty) {
      searchSongsList.value = songs;
    } else {
      searchSongsList.value = songs
          .where((song) => song.metas.title!.toLowerCase().contains(search))
          .toList();
    }
    update();
  }

  void deletePlaylist(int key) async {
    await _audioRoom.deletePlaylist(key);
    getPlaylist();
    update();
  }

  void editPlaylist(int key, String name) async {
    await _audioRoom.renamePlaylist(key, name);
    getPlaylist();
    update();
  }

  void getPlaylist() async {
    playlist = await _audioRoom.queryPlaylists();
    update();
  }

  void createPlaylist(String name) async {
    _audioRoom.createPlaylist(name);
    getPlaylist();
    update();
  }

  void deleteFromPlaylist(int id, int key) async {
    await _audioRoom.deleteFrom(RoomType.PLAYLIST, id, playlistKey: key);
    update();
  }

  void notificationCheck(bool condition) {
    notification = condition;
    update();
  }

  requestPermission() async {
    permissionStatus = await _audioQuery.permissionsStatus();
    if (permissionStatus) {
    } else {
      permissionStatus = await _audioQuery.permissionsRequest();
    }
    fetchSongs();
    searchSongsList.value = songs;
    getFavorites();
    getPlaylist();
    update();
  }

  void changeHomepageIndex(int index) {
    homepageIndex = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    requestPermission();
  }
}
