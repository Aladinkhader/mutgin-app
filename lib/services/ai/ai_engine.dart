import '../../models/recitation_result.dart';

abstract class AiEngine {
  Future<RecitationResult> recognize({
    required List<int> audioData,
  });

  Future<void> initialize();

  Future<void> dispose();

  bool get isInitialized;
}
