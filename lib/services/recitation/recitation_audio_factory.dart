import '../ai/recitation_engine.dart';
import '../ai/whisper/whisper_engine.dart';
import 'recitation_audio_controller.dart';
import 'recitation_audio_pipeline.dart';
import 'recitation_audio_processor.dart';
import 'recitation_audio_session.dart';

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

  static RecitationAudioPipeline createMockPipeline() {
    final engine = RecitationEngine(
      aiEngine: WhisperEngine(),
    );

    return RecitationAudioPipeline(
      processor: const RecitationAudioProcessor(),
      engine: engine,
      session: RecitationAudioSession(),
    );
  }
}
