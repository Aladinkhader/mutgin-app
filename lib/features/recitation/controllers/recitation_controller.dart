import 'package:flutter/foundation.dart';

import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../../../services/ai/recitation_engine.dart';
import '../../../services/recitation/recitation_session.dart';

class RecitationController extends ChangeNotifier {
  final RecitationEngine engine;
  final RecitationSession session;

  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  bool _isProcessing = false;

  RecitationController({
    required this.engine,
    RecitationSession? session,
  }) : session = session ?? RecitationSession();

  RecitationResult get result => _result;

  Ayah? get currentAyah => session.currentAyah;

  bool get isProcessing => _isProcessing;

  bool get isActive => session.isActive;

  Future<void> start(Ayah ayah) async {
    session.start(ayah);

    _result = const RecitationResult(
      status: RecitationStatus.listening,
    );

    notifyListeners();
  }

  Future<void> processAudio(List<int> audioData) async {
    final ayah = currentAyah;

    if (ayah == null || !isActive || _isProcessing) {
      return;
    }

    _isProcessing = true;

    _result = session.update(
      status: RecitationStatus.processing,
    );

    notifyListeners();

    try {
      _result = await engine.process(
        audioData: audioData,
        expectedText: ayah.text,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
    } catch (error) {
      _result = RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        expectedText: ayah.text,
        errorMessage: 'حدث خطأ أثناء معالجة التلاوة.',
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void stop() {
    session.stop();

    _result = const RecitationResult(
      status: RecitationStatus.idle,
    );

    _isProcessing = false;

    notifyListeners();
  }
}
