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

  RecitationSessionState get state => manager.state;

  Ayah? get currentAyah => manager.currentAyah;

  List<RecitationError> get errors => manager.errors;

  double get accuracy => manager.accuracy;

  bool get isActive => manager.isActive;

  bool get isListening =>
      state == RecitationSessionState.listening;

  bool get isAnalyzing =>
      state == RecitationSessionState.analyzing;

  bool get isCompleted =>
      state == RecitationSessionState.completed;

  bool get hasError =>
      state == RecitationSessionState.error;

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

  void reset() {
    manager.reset();
    notifyListeners();
  }
}
