class WhisperModelConfig {
  final String modelName;
  final String modelUrl;
  final String modelFileName;
  final int sampleRate;
  final int channels;
  final int bytesPerSample;
  final int maxAudioSeconds;

  const WhisperModelConfig({
    required this.modelName,
    required this.modelUrl,
    required this.modelFileName,
    this.sampleRate = 16000,
    this.channels = 1,
    this.bytesPerSample = 2,
    this.maxAudioSeconds = 30,
  });

  /// نموذج Tarteel العربي المخصص للقرآن بعد تحويله إلى GGML Q8_0.
  /// النسخة المضغوطة مناسبة للتشغيل المحلي على الهاتف عبر whisper.cpp.
  static const quranArabicBase = WhisperModelConfig(
    modelName: 'whisper-base-ar-quran-ggml',
    modelUrl:
        'https://huggingface.co/sadrapp/whisper-base-ar-quran-ggml',
    modelFileName: 'ggml-model-q8_0.bin',
  );

  int get maxAudioBytes =>
      sampleRate *
      channels *
      bytesPerSample *
      maxAudioSeconds;

  bool isValidAudioLength(int byteLength) {
    if (byteLength <= 0) {
      return false;
    }

    return byteLength <= maxAudioBytes;
  }
}
