import '../../models/ayah.dart';
import '../../models/recitation_error.dart';
import '../../models/recitation_result.dart';
import 'recitation_analyzer.dart';
import 'recitation_session_state.dart';

class RecitationSessionManager {
  final RecitationAnalyzer analyzer;

  Ayah? _currentAyah;
  RecitationSessionState _state = RecitationSessionState.idle;
  List<RecitationError> _errors = const [];
  double _accuracy = 0.0;

  RecitationSessionManager({
    RecitationAnalyzer? analyzer,
  }) : analyzer = analyzer ?? const RecitationAnalyzer();

  Ayah? get currentAyah => _currentAyah;

  RecitationSessionState get state => _state;

  List<RecitationError> get errors => List.unmodifiable(_errors);

  double get accuracy => _accuracy;

  bool get isActive =>
      _state == RecitationSessionState.preparing ||
      _state == RecitationSessionState.listening ||
      _state == RecitationSessionState.analyzing;

  void start(Ayah ayah) {
    _currentAyah = ayah;
    _errors = const [];
    _accuracy = 0.0;
    _state = RecitationSessionState.preparing;
  }

  void startListening() {
    if (_currentAyah == null) {
      return;
    }

    _state = RecitationSessionState.listening;
  }

  RecitationResult analyze({
    required String recognizedText,
    double confidence = 1.0,
  }) {
    final ayah = _currentAyah;

    if (ayah == null) {
      return const RecitationResult(
        status: RecitationStatus.idle,
      );
    }

    _state = RecitationSessionState.analyzing;

    _errors = analyzer.analyze(
      expectedText: ayah.text,
      recognizedText: recognizedText,
    );

    _accuracy = analyzer.calculateAccuracy(
      expectedText: ayah.text,
      recognizedText: recognizedText,
    );

    final isCorrect = _errors.isEmpty;

    _state = isCorrect
        ? RecitationSessionState.completed
        : RecitationSessionState.error;

    return RecitationResult(
      status: isCorrect
          ? RecitationStatus.correct
          : RecitationStatus.mistake,
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      recognizedText: recognizedText,
      expectedText: ayah.text,
      confidence: confidence,
      errorMessage: isCorrect
          ? null
          : 'تم اكتشاف ${_errors.length} مواضع تحتاج إلى مراجعة.',
    );
  }

  void reset() {
    _currentAyah = null;
    _state = RecitationSessionState.idle;
    _errors = const [];
    _accuracy = 0.0;
  }
}
