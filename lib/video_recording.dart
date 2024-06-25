import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:grip_fixer/state.dart';
import 'package:provider/provider.dart';
import 'package:grip_fixer/session_measurements.dart';
import 'video_playing.dart';
import 'dart:async';

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
  final Completer<void> completer = Completer();
  int? currentResponseValue;
  Timer? _characteristicTimer;
  String? _videoFilePath;
  late bool violating = false;
  List sessionData = [];
  late int startTime;
  int start = DateTime.now().millisecondsSinceEpoch;
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _controller = CameraController(front, ResolutionPreset.max);
    await _controller.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    saveToDatabase(state);
    if (_isRecording) {
      final file = await _controller.stopVideoRecording();
      setState(() => _isRecording = false);
      setState(() {
        _isRecording = false;
        _videoFilePath = file.path;
      });
      state.session?.violations = sessionData;
      var db = state.sqfl;
      db.updateSession(state.session!);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      startTime = DateTime.now().millisecondsSinceEpoch;
      sessionData = [];
      await _controller.prepareForVideoRecording();
      await _controller.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _characteristicTimer?.cancel();
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
      var service = services
          .where((s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214"))
          .first;
      var requestCharacteristic = service.characteristics
          .where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215"))
          .first;
      responseCharacteristic = service.characteristics
          .where((s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216"))
          .first;
      responseCharacteristic!.onValueReceived.listen((value) {
        int sessionID = state.session?.session_id ?? 0;
        SessionMeasurements sessionMeasurements = SessionMeasurements(
          session_id: sessionID,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          value: value[0] & 0xFF |
              ((value[1] & 0xFF) << 8) |
              ((value[2] & 0xFF) << 16) |
              ((value[3] & 0xFF) << 24),
        );
        currentResponseValue = sessionMeasurements.value;
        saveToDatabase(state);
        _characteristicTimer?.cancel();
        _characteristicTimer =
            Timer(const Duration(seconds: 2), _onCharacteristicTimeout);
      });
      responseCharacteristic!.setNotifyValue(true);
      requestCharacteristic.write([1]);
      _characteristicTimer =
          Timer(const Duration(seconds: 2), _onCharacteristicTimeout);
    });
  }

  void _onCharacteristicTimeout() async {
    if (_isRecording) {
      final file = await _controller.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoFilePath = file.path;
      });
    }
    _showBluetoothDisconnectedDialog();
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
    if (sessionMeasurements.value! > state.target!.grip_strength!.toInt() &&
        violating == false) {
      sessionData.add((sessionMeasurements.timestamp! - start) ~/ 1000);
      violating = true;
    } else if (sessionMeasurements.value! <
            state.target!.grip_strength!.toInt() &&
        violating == true) {
      violating = false;
    }

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

  void _showBluetoothDisconnectedDialog() {
    // Save session measurements if not already saved
    if (state.session != null && state.sessionMeasurements != null) {
      saveToDatabase(state);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          title: const Text('Bluetooth Disconnected'),
          content: const Text(
              'Would you like to retry the connection or end the session?'),
          actions: [
            TextButton(
              child: const Text('Retry Connection'),
              onPressed: () {
                Navigator.of(context).pop();
                _retryBluetoothConnection();
              },
            ),
            TextButton(
              child: const Text('End Session'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _isRecording = false);
                final route = MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => VideoPage(filePath: _videoFilePath ?? ''),
                );
                Navigator.push(context, route);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _retryBluetoothConnection() async {
    int retryCount = 0;
    const maxRetries = 3;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          canPop: false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Retrying connection..."),
              ],
            ),
          ),
        );
      },
    );
    while (retryCount < maxRetries) {
      try {
        setState(() => isConnecting = true);

        BluetoothDevice? device = state.bluetoothDevice;
        if (device == null) {
          throw Exception('Bluetooth device is null');
        }

        await device.connect(timeout: const Duration(seconds: 30));
        List<BluetoothService> services =
            await device.discoverServices(timeout: 30);

        var service = services
            .where(
                (s) => s.uuid == Guid("19b10000-e8f2-537e-4f6c-d104768a1214"))
            .first;
        var requestCharacteristic = service.characteristics
            .where(
                (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1215"))
            .first;
        var responseCharacteristic = service.characteristics
            .where(
                (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1216"))
            .first;
        var maxGripStrengthCharacteristic = service.characteristics
            .where(
                (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1217"))
            .first;
        var targetGripPercentageCharacteristic = service.characteristics
            .where(
                (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1218"))
            .first;
        var enableFeedbackCharacteristic = service.characteristics
            .where(
                (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1219"))
            .first;
        var sensorNumberCharacteristic = service.characteristics
            .where(
                (s) => s.uuid == Guid("19b10001-e8f2-537e-4f6c-d104768a1220"))
            .first;
        state.targetGripPercentageCharacteristic =
            targetGripPercentageCharacteristic;
        state.maxGripStrengthCharacteristic = maxGripStrengthCharacteristic;
        state.enableFeedbackCharacteristic = enableFeedbackCharacteristic;
        state.sensorNumberCharacteristic = sensorNumberCharacteristic;
        if (!completer.isCompleted) {
          completer.complete();
        }

        responseCharacteristic.setNotifyValue(true);
        setState(() => isConnecting = false);
        await Future.delayed(const Duration(seconds: 5));

        BluetoothConnectionState currentState =
            await device.connectionState.first;
        if (currentState == BluetoothConnectionState.connected) {
          Navigator.of(context).pop();
          _showReconnectedDialog();
          return;
        } else {
          throw Exception('Failed to establish a stable connection');
        }
      } catch (exception) {
        print('Bluetooth connection attempt failed: $exception');
        retryCount++;

        if (retryCount >= maxRetries) {
          Navigator.of(context).pop();
          _showConnectionFailedDialog();
          return;
        }
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  void _showReconnectedDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bluetooth Reconnected'),
        content:
            const Text('The Bluetooth connection has been re-established.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isRecording = false;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showConnectionFailedDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bluetooth Connection Failed'),
        content: const Text(
            'Unable to re-establish the Bluetooth connection after multiple attempts.'),
        actions: [
          TextButton(
            child: const Text('End Session'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _isRecording = false);
              final route = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => VideoPage(filePath: _videoFilePath ?? ''),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
    );
  }
}
