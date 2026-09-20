import '../../models/recitation_result.dart';
import 'ai_engine.dart';

class MockAiEngine implements AiEngine {
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<RecitationResult> recognize({
    required List<int> audioData,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (audioData.isEmpty) {
      return const RecitationResult(
        status: RecitationStatus.processing,
        confidence: 0.0,
        errorMessage: 'لم يتم استلام تسجيل صوتي.',
      );
    }

    return const RecitationResult(
      status: RecitationStatus.processing,
      confidence: 0.0,
      errorMessage: 'محرك التعرف الصوتي الحقيقي لم يتم ربطه بعد.',
    );
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }
}
