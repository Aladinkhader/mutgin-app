import '../ai/mock_ai_engine.dart';
import '../ai/recitation_engine.dart';
import 'recitation_audio_controller.dart';

abstract final class RecitationAudioFactory {
  static RecitationAudioController createController({
    RecitationEngine? engine,
  }) {
    return RecitationAudioController(
      engine: engine ??
          RecitationEngine(
            aiEngine: MockAiEngine(),
          ),
    );
  }

  static RecitationAudioController createMockController() {
    return createController(
      engine: RecitationEngine(
        aiEngine: MockAiEngine(),
      ),
    );
  }
}
