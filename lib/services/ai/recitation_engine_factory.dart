import 'recitation_engine.dart';
import 'whisper/whisper_engine.dart';

abstract final class RecitationEngineFactory {
  static RecitationEngine create() {
    return RecitationEngine(
      aiEngine: WhisperEngine(),
    );
  }
}
