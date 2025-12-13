import 'package:flutter/material.dart';
import 'package:lab5_music/music/audio_manager.dart';
import 'package:lab5_music/music/mini_player.dart';
import 'package:lab5_music/widgets/container_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // DỮ LIỆU GIẢ
  static final List<Map<String, String>> _mockTracks = [
    {
      "id": "1",
      "title": "Mùa Hè Sôi Động (Pop)",
      "description": "Giai điệu Pop tươi vui...",
      "duration": "03:45",
      "imageUrl":
          "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=1000&auto=format&fit=crop",
      "audioUrl":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
    },
    {
      "id": "2",
      "title": "Chuyện Tình Mùa Đông (Ballad)",
      "description": "Bản Ballad nhẹ nhàng...",
      "duration": "04:12",
      "imageUrl":
          "https://images.unsplash.com/photo-1493225255756-d9584f8606e9?q=80&w=1000&auto=format&fit=crop",
      "audioUrl":
          "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3",
    },
    // ... (Giữ nguyên các bài khác của bạn)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Danh Sách Nhạc",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      // Dùng Stack để đè MiniPlayer lên trên ListView
      body: Stack(
        children: [
          // 1. Danh sách nhạc
          ValueListenableBuilder<Map<String, String>?>(
            valueListenable: AudioManager().currentSongNotifier,
            builder: (context, currentSong, child) {
              // Nếu có MiniPlayer thì thêm padding dưới đáy để không bị che
              return ListView.builder(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: currentSong != null
                      ? 100
                      : 16, // Padding bottom quan trọng
                ),
                itemCount: _mockTracks.length,
                itemBuilder: (context, index) {
                  final track = _mockTracks[index];

                  // Bọc InkWell để xử lý sự kiện phát nhạc qua AudioManager
                  return InkWell(
                    onTap: () {
                      // 1. Phát nhạc qua Singleton Manager
                      AudioManager().play(track);

                      // 2. Mở màn hình chi tiết (Nếu muốn mở ngay)
                      // Navigator.push(context, MaterialPageRoute(...));
                      // Gợi ý: Tạm thời không navigate ngay để test Mini Player trước
                    },
                    child: ContainerWidget(
                      id: track["id"]!,
                      title: track["title"]!,
                      description: track["description"]!,
                      duration: track["duration"]!,
                      imageUrl: track["imageUrl"],
                      audioUrl: track["audioUrl"]!,
                    ),
                  );
                },
              );
            },
          ),

          // 2. Mini Player Widget (Chỉ hiện khi có bài hát đang chọn)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ValueListenableBuilder<Map<String, String>?>(
              valueListenable: AudioManager().currentSongNotifier,
              builder: (context, currentSong, child) {
                if (currentSong == null) {
                  return const SizedBox.shrink(); // Ẩn nếu chưa chọn bài
                }

                return MiniPlayerWidget(song: currentSong);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Mini Player tách riêng cho gọn
