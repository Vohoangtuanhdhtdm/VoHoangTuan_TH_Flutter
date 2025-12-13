import 'package:flutter/material.dart';
import 'package:lab5_music/music/audio_manager.dart';
import 'package:lab5_music/music/media_player_screen.dart';

class MiniPlayerWidget extends StatelessWidget {
  final Map<String, String> song;

  const MiniPlayerWidget({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Khi bấm vào thanh nhỏ -> Mở Full Player Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPlayerScreen(
              id: song['id']!,
              title: song['title']!,
              description: song['description']!,
              imageUrl: song['imageUrl'],
              audioUrl: song['audioUrl']!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 38, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.indigo.shade900, // Màu nền tối
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ảnh nhỏ quay quay (Optional: có thể thêm animation)
            Hero(
              tag: "mini_${song['id']}", // Tag khác với list để tránh lỗi
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  song['imageUrl'] ??
                      "https://i.pinimg.com/736x/47/c5/0f/47c50f916191cea017c4582e140d493f.jpg",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Thông tin bài hát
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song['description']!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Nút Play/Pause
            ValueListenableBuilder<bool>(
              valueListenable: AudioManager().isPlayingNotifier,
              builder: (context, isPlaying, child) {
                return IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      AudioManager().pause();
                    } else {
                      AudioManager().resume();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
