import '../ai/mock_ai_engine.dart';
import '../ai/recitation_engine.dart';
import 'recitation_analyzer.dart';
import 'recitation_pipeline.dart';
import 'recitation_session_manager.dart';

abstract final class RecitationFactory {
  static RecitationSessionManager createSessionManager() {
    return RecitationSessionManager(
      analyzer: const RecitationAnalyzer(),
    );
  }

  static RecitationPipeline createPipeline(
    RecitationSessionManager sessionManager,
  ) {
    final aiEngine = MockAiEngine();

    final engine = RecitationEngine(
      aiEngine: aiEngine,
      analyzer: const RecitationAnalyzer(),
    );

    return RecitationPipeline(
      engine: engine,
      sessionManager: sessionManager,
    );
  }
}
