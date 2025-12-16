import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart'; // Bắt buộc import

class AudioManager {
  // --- SINGLETON PATTERN ---
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal() {
    // Lắng nghe trạng thái của Player ngay khi khởi tạo
    // Giúp đồng bộ UI khi người dùng bấm nút trên Thanh thông báo (Notification)
    player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      // Cập nhật biến trạng thái cho UI
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        // Có thể thêm logic loading nếu muốn
      } else {
        isPlayingNotifier.value = isPlaying;
      }

      // Nếu nhạc chạy hết bài -> Reset về trạng thái Pause
      if (processingState == ProcessingState.completed) {
        player.stop();
        player.seek(Duration.zero);
        isPlayingNotifier.value = false;
      }
    });
  }

  final AudioPlayer player = AudioPlayer();

  // ValueNotifier để UI lắng nghe
  final ValueNotifier<Map<String, String>?> currentSongNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);

  // --- HÀM PHÁT NHẠC ---
  Future<void> play(Map<String, String> song) async {
    try {
      // 1. Nếu chọn bài mới
      if (currentSongNotifier.value?['id'] != song['id']) {
        currentSongNotifier.value = song;

        // Xử lý URL (Fallback nếu rỗng)
        String url = song['audioUrl'] ?? '';
        if (url.isEmpty) {
          url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
        }

        // --- CẤU HÌNH BACKGROUND AUDIO SOURCE ---
        final audioSource = AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            // Các thông tin này sẽ hiện trên thanh thông báo
            id: song['id']!,
            album: "Music App Lab 5",
            title: song['title'] ?? "Unknown Title",
            artist: song['description'] ?? "Unknown Artist",
            artUri: Uri.parse(
              song['imageUrl'] ??
                  "https://i.pinimg.com/736x/47/c5/0f/47c50f916191cea017c4582e140d493f.jpg",
            ),
          ),
        );

        // Nạp nguồn nhạc và phát
        await player.setAudioSource(audioSource);
        player.play();
      }
      // 2. Nếu chọn lại bài đang phát -> Toggle Play/Pause
      else {
        if (player.playing) {
          player.pause();
        } else {
          player.play();
        }
      }
    } catch (e) {
      debugPrint("Lỗi phát nhạc: $e");
    }
  }

  // Các hàm điều khiển cơ bản
  void pause() {
    player.pause();
  }

  void resume() {
    player.play();
  }

  void seek(Duration position) {
    player.seek(position);
  }

  // Hàm giải phóng tài nguyên khi tắt hẳn app (ít dùng trong singleton nhưng nên có)
  void dispose() {
    player.dispose();
  }
}
