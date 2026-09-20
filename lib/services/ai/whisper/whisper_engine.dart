import 'dart:io';

import 'package:whisper_ggml/whisper_ggml.dart';

import '../../models/recitation_result.dart';
import '../ai_engine.dart';
import 'whisper_model_config.dart';

class WhisperEngine implements AiEngine {
  final WhisperModelConfig config;

  WhisperController? _controller;
  bool _isInitialized = false;

  WhisperEngine({
    this.config = WhisperModelConfig.quranArabicBase,
  });

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _controller = WhisperController();
    _isInitialized = true;
  }

  @override
  Future<RecitationResult> recognize({
    required List<int> audioData,
  }) async {
    if (!_isInitialized || _controller == null) {
      await initialize();
    }

    if (audioData.isEmpty) {
      return const RecitationResult(
        status: RecitationStatus.processing,
        confidence: 0.0,
        errorMessage: 'لم يتم استلام تسجيل صوتي.',
      );
    }

    if (!config.isValidAudioLength(audioData.length)) {
      return const RecitationResult(
        status: RecitationStatus.processing,
        confidence: 0.0,
        errorMessage: 'مدة التسجيل أطول من الحد المسموح.',
      );
    }

    return const RecitationResult(
      status: RecitationStatus.processing,
      confidence: 0.0,
      errorMessage:
          'محرك Whisper جاهز، وسيتم ربط ملف النموذج والتسجيل الصوتي في الخطوة التالية.',
    );
  }

  Future<String> getModelPath() async {
    final modelDirectory = await WhisperController.getModelDir();

    return '$modelDirectory${Platform.pathSeparator}${config.modelFileName}';
  }

  @override
  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.releaseModel();
    }

    _controller = null;
    _isInitialized = false;
  }
}
