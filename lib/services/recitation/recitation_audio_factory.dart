import '../ai/recitation_engine.dart';
import '../ai/mock_ai_engine.dart';
import 'recitation_audio_controller.dart';
import 'recitation_audio_pipeline.dart';
import 'recitation_audio_processor.dart';

abstract final class RecitationAudioFactory {
  static RecitationAudioPipeline createPipeline({
    required RecitationEngine engine,
  }) {
    return RecitationAudioPipeline(
      audioController: RecitationAudioController(),
      processor: const RecitationAudioProcessor(),
      engine: engine,
    );
  }

  static RecitationAudioPipeline createMockPipeline() {
    final engine = RecitationEngine(
      aiEngine: MockAiEngine(),
    );

    return createPipeline(
      engine: engine,
    );
  }
}
