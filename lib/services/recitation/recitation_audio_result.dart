class RecitationAudioResult {
  final List<int> audioData;
  final int sampleRate;
  final int channelCount;
  final Duration duration;

  const RecitationAudioResult({
    required this.audioData,
    required this.sampleRate,
    required this.channelCount,
    required this.duration,
  });

  bool get isEmpty => audioData.isEmpty;

  bool get isMono => channelCount == 1;

  bool get is16Khz => sampleRate == 16000;
}
