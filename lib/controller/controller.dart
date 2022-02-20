import 'package:assets_audio_player/assets_audio_player.dart';

final assetsAudioPlayer = AssetsAudioPlayer();
void play(List<Audio> audio, int index) {
  assetsAudioPlayer.open(Playlist(audios: audio, startIndex: index),
      showNotification: true,
      notificationSettings: NotificationSettings(stopEnabled: false));
  // print(widget.audio);
}
