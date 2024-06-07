import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;
  const VideoPage({Key? key, required this.filePath}) : super(key: key);
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              //if directory doesn't exist create folder with create()
              final directory = await getApplicationDocumentsDirectory();
              //name the file and put it in a directory
              //how to find files?
              // /data/user/0/com.example.grip_fixer/app_flutter
              // "/data/user/0/com.example.grip_fixer/cache/REC1546865709558824649.temp"

              await File(widget.filePath).rename(
                  //how do we want to name files?
                  "${directory.path}/${state.session?.session_id}.mp4");
              //await File(widget.filePath).delete();
              //navigate to next page
              context.go("/WelcomePage");
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 675.0,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: FutureBuilder(
                  future: _initVideoPlayer(),
                  builder: (context, state) {
                    if (state.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return VideoPlayer(_videoPlayerController);
                    }
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(25),
            ),
          ],
        ),
      ),
    );
  }
}
