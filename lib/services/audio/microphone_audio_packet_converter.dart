import 'microphone_audio_packet.dart';

class MicrophoneAudioPacketConverter {
  const MicrophoneAudioPacketConverter();

  MicrophoneAudioPacket convert(
    List<int> audioData, {
    int sampleRate = 16000,
    int channelCount = 1,
    int bytesPerSample = 2,
  }) {
    return MicrophoneAudioPacket(
      data: List<int>.from(audioData),
      sampleRate: sampleRate,
      channelCount: channelCount,
      bytesPerSample: bytesPerSample,
    );
  }
}
