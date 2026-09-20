import '../ai/recitation_engine.dart';
import '../ai/whisper/whisper_engine.dart';
import 'recitation_audio_controller.dart';

abstract final class RecitationAudioFactory {
  static RecitationAudioController createController({
    RecitationEngine? engine,
  }) {
    return RecitationAudioController(
      engine: engine ??
          RecitationEngine(
            aiEngine: WhisperEngine(),
          ),
    );
  }

  static RecitationAudioController createMockController() {
    return createController();
  }
}
