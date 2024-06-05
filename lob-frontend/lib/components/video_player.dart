// ignore_for_file: deprecated_member_use

import 'package:lob_frontend/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  @override
  final String videoUrl;
  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    print(widget.videoUrl);
    _controller = VideoPlayerController.network(
      widget.videoUrl,
      httpHeaders: {'ngrok-skip-browser-warning': '69420'}
    )..initialize().then((_) {
        setState(() {
          // Ensure that the _chewieController is created after _controller is initialized
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: true,
            looping: true,
          );
          _isLoaded = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded != false ? Expanded(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Chewie(
                        controller: _chewieController,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ): Container(
        width: 50,
        height: 50,
        child: const CircularProgressIndicator(color: AppColors.selected),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}


