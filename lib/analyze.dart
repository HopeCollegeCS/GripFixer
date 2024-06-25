import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip_fixer/gripFixerDrawer.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});
  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreen();
}

int excess = 0;
int seconds = 0;

Future<void> showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('AlertDialog Title'),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: <Widget>[
                // Row(
                //   children: [
                //     const Text(
                //         'Show times when recorded tension exceeds target by '),
                //     TextField(),
                //   ],
                // ),
                TextFormField(),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//
class _AnalyzeScreen extends State<AnalyzeScreen> {
  bool watchViolations = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  Future _initVideoPlayer() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    var state = Provider.of<AppState>(context, listen: false);
    var filename = '$path/${state.session?.session_id}.mp4';
    File file = File(filename);
    _controller = VideoPlayerController.file(file);
    _controller.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context, listen: false);
    List? numbers = state.session!.violations;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5482ab),
        leading: IconButton(
          color: (const Color(0xFFFFFFFF)),
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          child: Row(
            children: [
              const Text('Grip Strength Tool'),
              const SizedBox(width: 10),
              // const Icon(
              //   Icons.sports_tennis,
              // ),
              const SizedBox(width: 10),
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.sports_tennis),
                    color: (const Color(0xFFFFFFFF)),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 40.0),

          const Align(
            alignment: Alignment.center,
            child: Text(
              "Grip Strength Tool",
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10.0),

          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Practicing',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10.0),
                Text('${state.session?.shot_type}',
                    style: const TextStyle(fontSize: 18))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Target Grip Strength',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10.0),
                Text('${state.person?.strength}',
                    style: const TextStyle(fontSize: 18))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Text('Show violations only',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Switch(
                  // This bool value toggles the switch.
                  value: watchViolations,
                  activeColor: Colors.black,
                  onChanged: (value) {
                    if (state.session?.violations?.isEmpty == true ||
                        state.session?.violations == null) {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text('No available violations'),
                                content: const Text(
                                    'There are no violations associated with this session'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    } else {
                      setState(() {
                        watchViolations = value;
                      });
                    }
                    // This is called when the user toggles the switch.
                  },
                ),
                IconButton(
                    onPressed: () {
                      final snackBar = SnackBar(
                        content: const Text('Yay! A SnackBar!'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    icon: const Icon(Icons.settings)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: !watchViolations
                    ? null
                    : () {
                        _controller.play();
                        Duration currentPosition = _controller.value.position;
                        late int newTime;

                        for (int i = 0; i < numbers!.length; i++) {
                          if (currentPosition.inSeconds >=
                              numbers[numbers.length - 1]) {
                            newTime = numbers[numbers.length - 2];
                            break;
                          }
                          if ((numbers[i] > currentPosition.inSeconds)) {
                            if (i >= 2) {
                              newTime = numbers[i - 2];
                              break;
                            }
                            newTime = 0;
                            break;
                          }
                          newTime = 0;
                        }
                        Duration targetPosition = Duration(seconds: newTime);
                        _controller.seekTo(targetPosition);
                      },
                child: const Text("Watch previous violation"),
              ),
              TextButton(
                onPressed: !watchViolations
                    ? null
                    : () {
                        _controller.play();
                        Duration currentPosition = _controller.value.position;
                        late int newTime;
                        for (int i = 0; i < numbers!.length; i++) {
                          if (numbers[i] > currentPosition.inSeconds) {
                            newTime = numbers[i];
                            break;
                          }
                          newTime = _controller.value.duration.inSeconds;
                        }
                        Duration targetPosition = Duration(seconds: newTime);
                        _controller.seekTo(targetPosition);
                      },
                child: const Text("Watch next violation"),
              ),
            ],
          ),

// Use a FutureBuilder to display a loading spinner while waiting for the
          // VideoPlayerController to finish initializing.
          SizedBox(
            height: 550.0,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: FutureBuilder(
                future: _initVideoPlayer(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the VideoPlayerController has finished initialization, use
                    // the data it provides to limit the aspect ratio of the video.
                    // return AspectRatio(
                    //   aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    return VideoPlayer(_controller);
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown.
              // If the video is playing, pause it.
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                // If the video is paused, play it.
                _controller.play();
              }
            },
            // Display the correct icon depending on the state of the player.
            child: const Icon(
                // _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                Icons.play_arrow),
          ),
        ]),
      ),
      drawer: const GripFixerDrawer(),
    );
  }
}
