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

  static const quranArabicBase = WhisperModelConfig(
    modelName: 'whisper-base-ar-quran',
    modelUrl:
        'https://huggingface.co/tarteel-ai/whisper-base-ar-quran',
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
