import 'recitation_audio_config.dart';
import 'recitation_audio_result.dart';

class RecitationAudioValidator {
  const RecitationAudioValidator();

  bool isValid(RecitationAudioResult result) {
    if (result.isEmpty) {
      return false;
    }

    if (!result.isMono) {
      return false;
    }

    if (!result.is16Khz) {
      return false;
    }

    if (result.duration <
        RecitationAudioConfig.minimumRecitationDuration) {
      return false;
    }

    if (result.duration >
        RecitationAudioConfig.maximumRecitationDuration) {
      return false;
    }

    return true;
  }
}
