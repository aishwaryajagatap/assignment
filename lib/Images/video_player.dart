// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
 void initState() {
  super.initState();
  _controller = VideoPlayerController.networkUrl(
    Uri.parse(widget.url),
  )..initialize().then((_) {
    setState(() {});
  });
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: () => _controller.value.isPlaying ? _controller.pause() : _controller.play(),
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
