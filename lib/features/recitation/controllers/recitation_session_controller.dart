import 'package:flutter/foundation.dart';

import '../../../models/ayah.dart';
import '../../../models/recitation_error.dart';
import '../../../models/recitation_result.dart';
import '../../../services/recitation/recitation_session_manager.dart';
import '../../../services/recitation/recitation_session_state.dart';

class RecitationSessionController extends ChangeNotifier {
  final RecitationSessionManager manager;

  RecitationSessionController({
    RecitationSessionManager? manager,
  }) : manager = manager ?? RecitationSessionManager();

  Ayah? get currentAyah => manager.currentAyah;

  RecitationSessionState get state => manager.state;

  List<RecitationError> get errors => manager.errors;

  double get accuracy => manager.accuracy;

  bool get isActive => manager.isActive;

  void start(Ayah ayah) {
    manager.start(ayah);
    notifyListeners();
  }

  void startListening() {
    manager.startListening();
    notifyListeners();
  }

  RecitationResult analyze({
    required String recognizedText,
    double confidence = 1.0,
  }) {
    final result = manager.analyze(
      recognizedText: recognizedText,
      confidence: confidence,
    );

    notifyListeners();

    return result;
  }

  void updateFromResult(RecitationResult result) {
    final ayah = manager.currentAyah;

    if (ayah == null) {
      return;
    }

    final recognizedText = result.recognizedText;

    if (recognizedText == null ||
        recognizedText.trim().isEmpty) {
      return;
    }

    manager.analyze(
      recognizedText: recognizedText,
      confidence: result.confidence,
    );

    notifyListeners();
  }

  void reset() {
    manager.reset();
    notifyListeners();
  }
}
