import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}
class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    // assetsに指定したファイルを読み込む
    print("LOAD");
    _controller = VideoPlayerController.asset('assets/movie/aa.mp4');
    print("LOAD2");
    // 初期化処理
    _controller.initialize().then((_) {
      print("LOAD3");
      // 最初のフレームを描画するため初期化後に更新
      setState(() {});
      print("LOAD4");
    });
    print("LOAD5");
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          // 動画を表示
          child: VideoPlayer(_controller),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // 動画を最初から再生
                _controller
                    .seekTo(Duration.zero)
                    .then((_) => _controller.play());
              },
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () {
                // 動画を再生
                _controller.play();
              },
              icon: Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () {
                // 動画を一時停止
                _controller.pause();
              },
              icon: Icon(Icons.pause),
            ),
          ],
        ),
      ],
    );
  }
}