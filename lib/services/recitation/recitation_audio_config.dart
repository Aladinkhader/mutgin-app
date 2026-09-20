class RecitationAudioConfig {
  static const int sampleRate = 16000;
  static const int channelCount = 1;

  static const int bytesPerSample = 2;

  static const Duration chunkDuration =
      Duration(milliseconds: 500);

  static const Duration minimumRecitationDuration =
      Duration(milliseconds: 800);

  static const Duration maximumRecitationDuration =
      Duration(seconds: 30);

  const RecitationAudioConfig._();
}
