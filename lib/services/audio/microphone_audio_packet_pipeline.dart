import 'microphone_audio_packet.dart';
import 'microphone_audio_packet_buffer.dart';
import 'microphone_audio_packet_converter.dart';
import 'microphone_audio_packet_validator.dart';

class MicrophoneAudioPacketPipeline {
  final MicrophoneAudioPacketConverter converter;
  final MicrophoneAudioPacketValidator validator;
  final MicrophoneAudioPacketBuffer buffer;

  MicrophoneAudioPacketPipeline({
    this.converter = const MicrophoneAudioPacketConverter(),
    this.validator = const MicrophoneAudioPacketValidator(),
    MicrophoneAudioPacketBuffer? buffer,
  }) : buffer = buffer ?? MicrophoneAudioPacketBuffer();

  bool add(
    List<int> audioData, {
    int sampleRate = 16000,
    int channelCount = 1,
    int bytesPerSample = 2,
  }) {
    final packet = converter.convert(
      audioData,
      sampleRate: sampleRate,
      channelCount: channelCount,
      bytesPerSample: bytesPerSample,
    );

    if (!validator.isValid(packet)) {
      return false;
    }

    buffer.add(packet);
    return true;
  }

  List<int> takeAll() {
    return buffer.takeAll();
  }

  List<int> snapshot() {
    return buffer.snapshot();
  }

  void clear() {
    buffer.clear();
  }
}
