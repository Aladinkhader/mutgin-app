import 'dart:async';

import 'microphone_audio_service.dart';

class MicrophoneRecitationBridge {
  final MicrophoneAudioService microphone;

  StreamSubscription<List<int>>? _subscription;

  MicrophoneRecitationBridge({
    MicrophoneAudioService? microphone,
  }) : microphone = microphone ?? MicrophoneAudioService();

  bool get isListening => microphone.isListening;

  Stream<List<int>> get audioStream => microphone.audioStream;

  Future<bool> requestPermission() {
    return microphone.requestPermission();
  }

  Future<void> start() async {
    await microphone.startListening();
  }

  Future<void> stop() async {
    await microphone.stopListening();
    await cancelListening();
  }

  void listen(
    void Function(List<int> audioData) onAudio,
  ) {
    _subscription?.cancel();

    _subscription = microphone.audioStream.listen(
      onAudio,
      onError: (_) {},
    );
  }

  Future<void> cancelListening() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> dispose() async {
    await cancelListening();
    await microphone.dispose();
  }
}
