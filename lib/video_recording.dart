import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';
import 'package:grip_fixer/session_measurements.dart';
import 'video_playing.dart';

class VideoRecorderScreen extends StatefulWidget {
  const VideoRecorderScreen({
    super.key,
  });

  @override
  State<VideoRecorderScreen> createState() => _VideoRecorderScreenState();
}

class _VideoRecorderScreenState extends State<VideoRecorderScreen> {
  late CameraController _controller;
  bool _isRecording = false;
  bool _isLoading = true;
  AppState state = AppState();
  BluetoothCharacteristic? responseCharacteristic;
  int? currentResponseValue;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
    _controller = CameraController(front, ResolutionPreset.max);
    await _controller.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    saveToDatabase(state);
    if (_isRecording) {
      final file = await _controller.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _controller.prepareForVideoRecording();
      await _controller.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = Provider.of<AppState>(context, listen: false);
    if (state.bluetoothDevice != null) {
      subscribeToCharacteristic(state.bluetoothDevice!);
    } else {
      print('Bluetooth device is null');
    }
  }

  void subscribeToCharacteristic(BluetoothDevice device) {
    device.discoverServices().then((services) {
      var service = services.where((s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214")).first;
      var requestCharacteristic =
          service.characteristics.where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215")).first;
      responseCharacteristic =
          service.characteristics.where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216")).first;

      responseCharacteristic!.onValueReceived.listen((value) {
        int sessionID = state.session?.session_id ?? 0;
        SessionMeasurements sessionMeasurements = SessionMeasurements(
          session_id: sessionID,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          value: value[0] & 0xFF | ((value[1] & 0xFF) << 8) | ((value[2] & 0xFF) << 16) | ((value[3] & 0xFF) << 24),
        );
        //sessionMeasurementsList.add(sessionMeasurements);
        saveToDatabase(state);
      });
      responseCharacteristic!.setNotifyValue(true);
      requestCharacteristic.write([1]);
    });
  }

  SessionMeasurements createSessionMeasurements(int sessionID) {
    return SessionMeasurements(
      session_id: sessionID,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      value: currentResponseValue,
    );
  }

  void saveToDatabase(AppState state) {
    int id = state.session?.session_id ?? 0;
    SessionMeasurements sessionMeasurements = createSessionMeasurements(id);
    state.setSessionMeasurements(sessionMeasurements);
    var db = state.sqfl;
    db.insertSessionMeasurement(sessionMeasurements);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_controller),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
