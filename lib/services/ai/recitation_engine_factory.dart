import 'mock_ai_engine.dart';
import 'recitation_engine.dart';

abstract final class RecitationEngineFactory {
  static RecitationEngine createMock() {
    return RecitationEngine(
      aiEngine: MockAiEngine(),
    );
  }
}
