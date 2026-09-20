import '../../models/recitation_result.dart';
import '../ai/mock_ai_engine.dart';
import '../ai/recitation_engine.dart';
import 'recitation_audio_processor.dart';
import 'recitation_audio_session.dart';

class RecitationAudioController {
  final RecitationAudioSession session;
  final RecitationAudioProcessor processor;
  final RecitationEngine engine;

  RecitationResult _result = const RecitationResult(
    status: RecitationStatus.idle,
  );

  bool _isProcessing = false;

  RecitationAudioController({
    RecitationAudioSession? session,
    RecitationAudioProcessor? processor,
    RecitationEngine? engine,
  })  : session = session ?? RecitationAudioSession(),
        processor = processor ?? const RecitationAudioProcessor(),
        engine = engine ??
            RecitationEngine(
              aiEngine: MockAiEngine(),
            );

  RecitationResult get result => _result;

  bool get isActive => session.isActive;

  bool get isRecording => isActive;

  bool get isProcessing => _isProcessing;

  Duration get duration => session.duration;

  void start() {
    if (isActive || _isProcessing) {
      return;
    }

    session.start();

    _result = const RecitationResult(
      status: RecitationStatus.listening,
    );
  }

  void addAudio(List<int> audioData) {
    if (!isActive || _isProcessing || audioData.isEmpty) {
      return;
    }

    session.addAudio(audioData);
  }

  Future<void> stop({
    required String expectedText,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    if (!isActive || _isProcessing) {
      return;
    }

    _isProcessing = true;

    _result = RecitationResult(
      status: RecitationStatus.processing,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      expectedText: expectedText,
    );

    try {
      final audioResult = session.finish();

      if (audioResult == null) {
        _result = RecitationResult(
          status: RecitationStatus.processing,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          expectedText: expectedText,
          errorMessage: 'لم يتم تسجيل صوت صالح للتحليل.',
        );
        return;
      }

      final preparedAudio = processor.prepare(audioResult);

      if (preparedAudio.isEmpty) {
        _result = RecitationResult(
          status: RecitationStatus.processing,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          expectedText: expectedText,
          errorMessage: 'التسجيل الصوتي غير صالح للتحليل.',
        );
        return;
      }

      _result = await engine.process(
        audioData: preparedAudio,
        expectedText: expectedText,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
    } catch (_) {
      _result = RecitationResult(
        status: RecitationStatus.processing,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        expectedText: expectedText,
        errorMessage: 'حدث خطأ أثناء معالجة التسجيل الصوتي.',
      );
    } finally {
      _isProcessing = false;
    }
  }

  void cancel() {
    session.cancel();
    _isProcessing = false;

    _result = const RecitationResult(
      status: RecitationStatus.idle,
    );
  }

  void reset() {
    cancel();
  }

  void dispose() {
    session.cancel();
  }
}
