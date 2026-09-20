import 'recitation_audio_config.dart';
import 'recitation_audio_result.dart';

class RecitationAudioProcessor {
  const RecitationAudioProcessor();

  List<int> prepare(RecitationAudioResult result) {
    if (result.audioData.isEmpty) {
      return const [];
    }

    if (!result.isMono || !result.is16Khz) {
      return const [];
    }

    return _limitDuration(result);
  }

  List<int> _limitDuration(RecitationAudioResult result) {
    final maxBytes =
        _bytesForDuration(RecitationAudioConfig.maximumRecitationDuration);

    if (result.audioData.length <= maxBytes) {
      return List<int>.from(result.audioData);
    }

    return result.audioData.sublist(0, maxBytes);
  }

  int _bytesForDuration(Duration duration) {
    final samples =
        (RecitationAudioConfig.sampleRate * duration.inMilliseconds) ~/ 1000;

    return samples *
        RecitationAudioConfig.channelCount *
        RecitationAudioConfig.bytesPerSample;
  }
}
