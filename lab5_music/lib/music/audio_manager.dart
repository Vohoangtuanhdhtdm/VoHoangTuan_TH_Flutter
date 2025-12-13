import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager {
  // Singleton: Chỉ tạo 1 instance duy nhất
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer player = AudioPlayer();

  // Dùng ValueNotifier để UI tự cập nhật khi bài hát thay đổi
  final ValueNotifier<Map<String, String>?> currentSongNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);

  // Hàm phát nhạc
  Future<void> play(Map<String, String> song) async {
    try {
      if (currentSongNotifier.value?['id'] != song['id']) {
        currentSongNotifier.value = song;
        // Kiểm tra url rỗng thì dùng link test
        String url = song['audioUrl'] ?? '';
        if (url.isEmpty)
          url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

        await player.setUrl(url);
        player.play();
        isPlayingNotifier.value = true;
      } else {
        // Nếu chọn lại bài cũ thì toggle play/pause
        if (player.playing) {
          player.pause();
          isPlayingNotifier.value = false;
        } else {
          player.play();
          isPlayingNotifier.value = true;
        }
      }
    } catch (e) {
      debugPrint("Lỗi phát nhạc: $e");
    }
  }

  void pause() {
    player.pause();
    isPlayingNotifier.value = false;
  }

  void resume() {
    player.play();
    isPlayingNotifier.value = true;
  }
}
