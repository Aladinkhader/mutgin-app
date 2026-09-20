import '../ai/mock_ai_engine.dart';
import '../ai/recitation_engine.dart';
import 'recitation_audio_controller.dart';
import 'recitation_audio_pipeline.dart';
import 'recitation_audio_processor.dart';
import 'recitation_audio_session.dart';

abstract final class RecitationAudioFactory {
  static RecitationAudioPipeline createPipeline({
    required RecitationEngine engine,
  }) {
    final session = RecitationAudioSession();

    late final RecitationAudioController controller;

    final pipeline = RecitationAudioPipeline(
      audioController: controller,
      processor: const RecitationAudioProcessor(),
      engine: engine,
      session: session,
    );

    controller = RecitationAudioController(
      pipeline: pipeline,
    );

    return pipeline;
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
