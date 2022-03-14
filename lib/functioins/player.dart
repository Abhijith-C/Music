import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:newmusic/controller/controller.dart';

final Controller controller = Get.put(Controller());
final assetsAudioPlayer = AssetsAudioPlayer();

void play(Audio audio) {
  var index = controller.songs.indexOf(audio);
  assetsAudioPlayer.open(Playlist(audios: controller.songs, startIndex: index),
      loopMode: LoopMode.playlist,
      showNotification: controller.notification,
      notificationSettings: const NotificationSettings(stopEnabled: false));
}

void playFrom(List<Audio> audio, index) {
  assetsAudioPlayer.open(Playlist(audios: audio, startIndex: index),
      loopMode: LoopMode.playlist,
      showNotification: controller.notification,
      notificationSettings: const NotificationSettings(stopEnabled: false));
}
