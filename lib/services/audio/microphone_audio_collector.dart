import 'dart:async';

class MicrophoneAudioCollector {
  final Stream<List<int>> audioStream;

  StreamSubscription<List<int>>? _subscription;

  void Function(List<int> audioData)? _onAudio;

  MicrophoneAudioCollector({
    required this.audioStream,
  });

  bool get isListening => _subscription != null;

  void start(void Function(List<int> audioData) onAudio) {
    if (isListening) {
      return;
    }

    _onAudio = onAudio;

    _subscription = audioStream.listen(
      (audioData) {
        if (audioData.isEmpty) {
          return;
        }

        _onAudio?.call(audioData);
      },
    );
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _onAudio = null;
  }

  Future<void> dispose() async {
    await stop();
  }
}
