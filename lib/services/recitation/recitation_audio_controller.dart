import 'recitation_audio_result.dart';
import 'recitation_audio_session.dart';

class RecitationAudioController {
  final RecitationAudioSession session;

  RecitationAudioController({
    RecitationAudioSession? session,
  }) : session = session ?? RecitationAudioSession();

  bool get isActive => session.isActive;

  Duration get duration => session.duration;

  void start() {
    session.start();
  }

  void addAudio(List<int> audioData) {
    session.addAudio(audioData);
  }

  RecitationAudioResult? stop() {
    return session.finish();
  }

  void cancel() {
    session.cancel();
  }
}
