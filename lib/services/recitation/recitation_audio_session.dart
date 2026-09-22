import 'recitation_audio_buffer.dart';
import 'recitation_audio_config.dart';
import 'recitation_audio_result.dart';
import 'recitation_audio_validator.dart';

class RecitationAudioSession {
  final RecitationAudioBuffer buffer;
  final RecitationAudioValidator validator;

  bool _isActive = false;
  DateTime? _startedAt;

  RecitationAudioSession({
    RecitationAudioBuffer? buffer,
    RecitationAudioValidator? validator,
  })  : buffer = buffer ?? RecitationAudioBuffer(),
        validator = validator ?? const RecitationAudioValidator();

  bool get isActive => _isActive;

  Duration get duration {
    final startedAt = _startedAt;

    if (!_isActive || startedAt == null) {
      return Duration.zero;
    }

    return DateTime.now().difference(startedAt);
  }

  void start() {
    buffer.clear();
    _startedAt = DateTime.now();
    _isActive = true;
  }

  void addAudio(List<int> audioData) {
    if (!_isActive || audioData.isEmpty) {
      return;
    }

    buffer.add(audioData);
  }

  RecitationAudioResult? finish() {
    if (!_isActive) {
      return null;
    }

    final elapsed = duration;
    final audioData = buffer.takeAll();

    _isActive = false;
    _startedAt = null;

    final result = RecitationAudioResult(
      audioData: audioData,
      sampleRate: RecitationAudioConfig.sampleRate,
      channelCount: RecitationAudioConfig.channelCount,
      duration: elapsed,
    );

    if (!validator.isValid(result)) {
      return null;
    }

    return result;
  }

  void cancel() {
    _isActive = false;
    _startedAt = null;
    buffer.clear();
  }
}
