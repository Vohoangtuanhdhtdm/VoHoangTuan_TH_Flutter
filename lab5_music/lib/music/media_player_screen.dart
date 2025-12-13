import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.audioUrl,
  });

  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String audioUrl;

  @override
  State<MediaPlayerScreen> createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  late AudioPlayer _audioPlayer;

  // Mock trạng thái Like cục bộ
  bool _isLikedMock = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();

    // Mock việc đánh dấu hoạt động (thay vì gọi API)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("MOCK: Đã đánh dấu hoạt động cho ngày hôm nay!");
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initAudio() async {
    try {
      // Nếu audioUrl là link thật thì dùng, nếu là chuỗi rỗng thì dùng link test
      String urlToPlay = widget.audioUrl.isNotEmpty
          ? widget.audioUrl
          : 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

      await _audioPlayer.setUrl(urlToPlay);
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Lỗi load nhạc: $e");
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "--:--";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent, // Làm trong suốt cho đẹp
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Nút Like Mock
          IconButton(
            icon: Icon(
              _isLikedMock ? Icons.favorite : Icons.favorite_border,
              color: _isLikedMock ? Colors.red : Colors.black,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                _isLikedMock = !_isLikedMock;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isLikedMock ? "Đã thích" : "Đã bỏ thích"),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Ảnh bìa
            Expanded(
              flex: 5,
              child: Hero(
                tag: widget.id,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    image: widget.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(widget.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            // Ảnh placeholder nếu null
                            image: NetworkImage(
                              "https://i.pinimg.com/736x/47/c5/0f/47c50f916191cea017c4582e140d493f.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tiêu đề & Mô tả
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Thanh trượt Slider
            StreamBuilder<Duration>(
              stream: _audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioPlayer.duration ?? Duration.zero;
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
                        ),
                        activeTrackColor: Colors.teal,
                        inactiveTrackColor: Colors.teal.shade100,
                        thumbColor: Colors.teal,
                      ),
                      child: Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble() > 0
                            ? duration.inSeconds.toDouble()
                            : 1.0, // Tránh lỗi chia cho 0
                        value: position.inSeconds.toDouble().clamp(
                          0,
                          (duration.inSeconds.toDouble() > 0
                              ? duration.inSeconds.toDouble()
                              : 1.0),
                        ),
                        onChanged: (value) {
                          _audioPlayer.seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // Các nút điều khiển
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;

                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return const CircularProgressIndicator(color: Colors.teal);
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay_10_rounded, size: 32),
                      onPressed: () {
                        // Tua lại 10s
                        _audioPlayer.seek(
                          _audioPlayer.position - const Duration(seconds: 10),
                        );
                      },
                    ),

                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          (playing == true)
                              ? Icons.pause
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          if (playing == true) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.forward_10_rounded,
                        size: 32,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        // Tua tới 10s
                        _audioPlayer.seek(
                          _audioPlayer.position + const Duration(seconds: 10),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.repeat, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
