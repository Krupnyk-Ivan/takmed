import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class VideoScreenWidget extends StatefulWidget {
  const VideoScreenWidget({super.key});

  @override
  State<VideoScreenWidget> createState() => _VideoScreenWidgetState();
}

class _VideoScreenWidgetState extends State<VideoScreenWidget> {
  late FlickManager _flickManager;

  @override
  void initState() {
    super.initState();
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.asset('assets/video1.mp4'),
    );
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: FlickVideoPlayer(flickManager: _flickManager),
            ),
            const SizedBox(height: 20),
            const Text(
              'Перше, на що слід звертати увагу, це зупинка масивної кровотечі. '
              'Це може бути зовнішня або внутрішня кровотеча, і вона є однією з основних причин смерті на полі бою. '
              'Пріоритетним методом є застосування турнікетів (для кінцівок) або прямий тиск на рани для зупинки кровотечі. '
              'Якщо кровотеча не зупиняється за допомогою простих методів, слід застосовувати більш складні техніки, '
              'наприклад, гемостазуючі засоби або операційні заходи (якщо це можливо).',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
