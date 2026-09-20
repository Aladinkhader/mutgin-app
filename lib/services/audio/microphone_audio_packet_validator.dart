import 'microphone_audio_packet.dart';

class MicrophoneAudioPacketValidator {
  const MicrophoneAudioPacketValidator();

  bool isValid(MicrophoneAudioPacket packet) {
    if (packet.isEmpty) {
      return false;
    }

    if (!packet.is16Khz) {
      return false;
    }

    if (!packet.isMono) {
      return false;
    }

    if (!packet.isPcm16) {
      return false;
    }

    return true;
  }
}
