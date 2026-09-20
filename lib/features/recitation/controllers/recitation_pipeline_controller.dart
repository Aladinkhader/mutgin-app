import 'package:flutter/foundation.dart';

import '../../../models/recitation_result.dart';
import '../../../services/recitation/recitation_pipeline.dart';
import '../../../services/recitation/recitation_session_manager.dart';
import '../../../services/recitation/recitation_session_state.dart';

class RecitationPipelineController extends ChangeNotifier {
  final RecitationPipeline pipeline;
  final RecitationSessionManager sessionManager;

  bool _isProcessing = false;
  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  RecitationPipelineController({
    required this.pipeline,
    required this.sessionManager,
  });

  bool get isProcessing => _isProcessing;

  RecitationResult get result => _result;

  RecitationSessionState get state => sessionManager.state;

  double get accuracy => sessionManager.accuracy;

  Future<void> processAudio(List<int> audioData) async {
    if (_isProcessing || sessionManager.currentAyah == null) {
      return;
    }

    _isProcessing = true;
    notifyListeners();

    try {
      _result = await pipeline.processAudio(
        audioData: audioData,
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void reset() {
    sessionManager.reset();

    _result = const RecitationResult(
      status: RecitationStatus.idle,
    );

    _isProcessing = false;
    notifyListeners();
  }
}
