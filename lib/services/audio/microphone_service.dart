import 'dart:async';

import 'audio_service.dart';

class MicrophoneService implements AudioService {
  final StreamController<List<int>> _audioController =
      StreamController<List<int>>.broadcast();

  bool _isListening = false;

  @override
  bool get isListening => _isListening;

  @override
  Stream<List<int>> get audioStream => _audioController.stream;

  @override
  Future<bool> requestPermission() async {
    // سيتم ربط صلاحية الميكروفون الفعلية هنا
    // عند إضافة حزمة تسجيل الصوت.
    return true;
  }

  @override
  Future<void> startListening() async {
    final granted = await requestPermission();

    if (!granted) {
      throw StateError('Microphone permission was not granted.');
    }

    _isListening = true;
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
  }

  Future<void> dispose() async {
    await _audioController.close();
  }
}
