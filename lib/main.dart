import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PickFilePage(),
    );
  }
}

class PickFilePage extends StatefulWidget {
  const PickFilePage({Key? key}) : super(key: key);

  @override
  State<PickFilePage> createState() => _PickFilePageState();
}

class _PickFilePageState extends State<PickFilePage> {
  Future<void> pick(ValueChanged<PlatformFile> goToVideo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      goToVideo(result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellow,
      child: Center(
        child: GestureDetector(
          onTap: () => pick(
            (file) => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => VideoPage(file: file)),
            ),
          ),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text('Go!', style: TextStyle(fontSize: 30, color: Colors.yellow)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class VideoPage extends StatefulWidget {
  final PlatformFile file;

  const VideoPage({
    required this.file,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.file.path!))
      ..initialize().then(
        (_) {
          setState(() {});
          _controller.play();
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: const Center(child: Icon(Icons.accessible_forward_sharp)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
