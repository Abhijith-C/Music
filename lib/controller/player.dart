import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:newmusic/screens/settings.dart';

final assetsAudioPlayer = AssetsAudioPlayer();
void play(List<Audio> audio, int index) {
  assetsAudioPlayer.open(Playlist(audios: audio, startIndex: index),
  loopMode: LoopMode.playlist,
      showNotification: notification,
      notificationSettings: NotificationSettings(stopEnabled: false));
}
