import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:whisper_ggml/whisper_ggml.dart';

import '../../models/recitation_result.dart';
import '../ai_engine.dart';
import 'whisper_model_config.dart';
import 'whisper_model_downloader.dart';

class WhisperEngine implements AiEngine {
  final WhisperModelConfig config;

  WhisperController? _controller;
  bool _isInitialized = false;
  String? _modelPath;

  WhisperEngine({
    this.config = WhisperModelConfig.quranArabicBase,
  });

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (_isInitialized && _modelPath != null) {
      return;
    }

    final directory = await getApplicationSupportDirectory();

    final modelFile = await WhisperModelDownloader(
      config: config,
    ).download(
      directory: directory,
    );

    if (!await modelFile.exists()) {
      throw FileSystemException(
        'لم يتم العثور على ملف نموذج Whisper.',
        modelFile.path,
      );
    }

    if (await modelFile.length() < 1024 * 1024) {
      throw FileSystemException(
        'ملف نموذج Whisper غير مكتمل.',
        modelFile.path,
      );
    }

    _controller = WhisperController();
    _modelPath = modelFile.path;
    _isInitialized = true;
  }

  @override
  Future<RecitationResult> recognize({
    required List<int> audioData,
  }) async {
    try {
      if (!_isInitialized ||
          _controller == null ||
          _modelPath == null) {
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

      final pcmBytes = Uint8List.fromList(audioData);

      final session = await _controller!.transcribeLive(
        modelPath: _modelPath!,
        pcm16Stream:
            Stream<Uint8List>.value(pcmBytes),
        lang: 'ar',
        initialPrompt:
            'القرآن الكريم، تلاوة عربية فصيحة، آيات القرآن الكريم.',
        suppressNonSpeechTokens: true,
        keepModelLoaded: true,
      );

      final text = (await session.stop()).trim();

      if (text.isEmpty) {
        return const RecitationResult(
          status: RecitationStatus.processing,
          confidence: 0.0,
          errorMessage: 'لم يتم التعرف على التلاوة بوضوح.',
        );
      }

      return RecitationResult(
        status: RecitationStatus.processing,
        recognizedText: text,
        confidence: 1.0,
      );
    } catch (error) {
      return RecitationResult(
        status: RecitationStatus.processing,
        confidence: 0.0,
        errorMessage:
            'تعذر تشغيل محرك Whisper: $error',
      );
    }
  }

  Future<String> getModelPath() async {
    if (_modelPath != null) {
      return _modelPath!;
    }

    await initialize();

    return _modelPath!;
  }

  @override
  Future<void> dispose() async {
    if (_controller != null) {
      await _controller!.releaseModel();
    }

    _controller = null;
    _modelPath = null;
    _isInitialized = false;
  }
}
