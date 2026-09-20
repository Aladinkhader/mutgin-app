import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'audio_service.dart';

class MicrophoneAudioService implements AudioService {
  static const MethodChannel _methodChannel =
      MethodChannel('com.mutqin.audio/microphone');

  static const EventChannel _eventChannel =
      EventChannel('com.mutqin.audio/microphone_stream');

  final StreamController<List<int>> _audioController =
      StreamController<List<int>>.broadcast();

  StreamSubscription<dynamic>? _nativeSubscription;

  bool _isListening = false;

  @override
  bool get isListening => _isListening;

  @override
  Stream<List<int>> get audioStream => _audioController.stream;

  @override
  Future<bool> requestPermission() async {
    try {
      final granted = await _methodChannel.invokeMethod<bool>(
        'requestPermission',
      );

      return granted ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<void> startListening() async {
    if (_isListening) {
      return;
    }

    final granted = await requestPermission();

    if (!granted) {
      throw StateError(
        'Microphone permission was not granted.',
      );
    }

    try {
      await _nativeSubscription?.cancel();

      _nativeSubscription = _eventChannel
          .receiveBroadcastStream()
          .listen(
        _handleNativeAudio,
        onError: (Object error) {
          if (!_audioController.isClosed) {
            _audioController.addError(error);
          }
        },
      );

      // Mark listening before starting the native recorder.
      // This prevents the first audio packets from being ignored.
      _isListening = true;

      await _methodChannel.invokeMethod<void>(
        'startRecording',
      );
    } on PlatformException catch (error) {
      _isListening = false;

      await _nativeSubscription?.cancel();
      _nativeSubscription = null;

      throw StateError(
        error.message ?? 'تعذر بدء تسجيل الصوت.',
      );
    } catch (error) {
      _isListening = false;

      await _nativeSubscription?.cancel();
      _nativeSubscription = null;

      throw StateError(
        error.toString(),
      );
    }
  }

  @override
  Future<void> stopListening() async {
    if (!_isListening) {
      return;
    }

    _isListening = false;

    try {
      await _methodChannel.invokeMethod<void>(
        'stopRecording',
      );
    } finally {
      await _nativeSubscription?.cancel();
      _nativeSubscription = null;
    }
  }

  void _handleNativeAudio(dynamic data) {
    if (!_isListening || data == null) {
      return;
    }

    if (data is Uint8List) {
      _audioController.add(
        List<int>.from(data),
      );
      return;
    }

    if (data is List<int>) {
      _audioController.add(
        List<int>.from(data),
      );
      return;
    }

    if (data is List) {
      _audioController.add(
        data.map((value) => value as int).toList(),
      );
    }
  }

  Future<void> dispose() async {
    try {
      await stopListening();
    } catch (_) {
      _isListening = false;
    }

    await _nativeSubscription?.cancel();
    _nativeSubscription = null;

    if (!_audioController.isClosed) {
      await _audioController.close();
    }
  }
}
