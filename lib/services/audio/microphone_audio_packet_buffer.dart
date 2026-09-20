import 'microphone_audio_packet.dart';

class MicrophoneAudioPacketBuffer {
  final List<int> _buffer = [];

  int get length => _buffer.length;

  bool get isEmpty => _buffer.isEmpty;

  bool get isNotEmpty => _buffer.isNotEmpty;

  void add(MicrophoneAudioPacket packet) {
    if (packet.isEmpty) {
      return;
    }

    _buffer.addAll(packet.data);
  }

  void addRaw(List<int> data) {
    if (data.isEmpty) {
      return;
    }

    _buffer.addAll(data);
  }

  List<int> takeAll() {
    final data = List<int>.from(_buffer);
    _buffer.clear();
    return data;
  }

  List<int> snapshot() {
    return List<int>.from(_buffer);
  }

  void clear() {
    _buffer.clear();
  }
}
