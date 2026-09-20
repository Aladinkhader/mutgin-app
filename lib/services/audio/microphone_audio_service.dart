import 'dart:async';

import 'audio_service.dart';

class MicrophoneAudioService implements AudioService {
  final StreamController<List<int>> _audioController =
      StreamController<List<int>>.broadcast();

  bool _isListening = false;

  @override
  bool get isListening => _isListening;

  @override
  Stream<List<int>> get audioStream => _audioController.stream;

  @override
  Future<bool> requestPermission() async {
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

  void addAudioData(List<int> audioData) {
    if (!_isListening || audioData.isEmpty) {
      return;
    }

    _audioController.add(List<int>.from(audioData));
  }

  Future<void> dispose() async {
    _isListening = false;
    await _audioController.close();
  }
}
