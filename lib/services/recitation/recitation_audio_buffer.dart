class RecitationAudioBuffer {
  final List<int> _buffer = [];

  int get length => _buffer.length;

  bool get isEmpty => _buffer.isEmpty;

  bool get isNotEmpty => _buffer.isNotEmpty;

  void add(List<int> audioData) {
    if (audioData.isEmpty) {
      return;
    }

    _buffer.addAll(audioData);
  }

  List<int> takeAll() {
    final data = List<int>.from(_buffer);
    _buffer.clear();
    return data;
  }

  void clear() {
    _buffer.clear();
  }
}
