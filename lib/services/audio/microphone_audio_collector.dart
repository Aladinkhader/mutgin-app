import 'dart:async';

class MicrophoneAudioCollector {
  final Stream<List<int>> audioStream;

  StreamSubscription<List<int>>? _subscription;

  MicrophoneAudioCollector({
    required this.audioStream,
  });

  bool get isListening => _subscription != null;

  void start(
    void Function(List<int> audioData) onAudio,
  ) {
    _subscription?.cancel();

    _subscription = audioStream.listen(
      (audioData) {
        if (audioData.isEmpty) {
          return;
        }

        onAudio(audioData);
      },
      onError: (_) {},
    );
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> dispose() async {
    await stop();
  }
}
