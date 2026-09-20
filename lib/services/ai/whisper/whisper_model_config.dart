class WhisperModelConfig {
  final String modelName;
  final String modelUrl;
  final int sampleRate;
  final int channels;
  final int bytesPerSample;
  final int maxAudioSeconds;

  const WhisperModelConfig({
    required this.modelName,
    required this.modelUrl,
    this.sampleRate = 16000,
    this.channels = 1,
    this.bytesPerSample = 2,
    this.maxAudioSeconds = 30,
  });

  /// نموذج Whisper العربي المخصص للقرآن من Tarteel
  /// بصيغة GGML المتوافقة مع whisper.cpp.
  static const quranArabicBase = WhisperModelConfig(
    modelName: 'ggml-whisper-base-ar-quran-q8_0',
    modelUrl:
        'https://huggingface.co/Alfatih/whisper-base-ar-quran-ggml',
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
