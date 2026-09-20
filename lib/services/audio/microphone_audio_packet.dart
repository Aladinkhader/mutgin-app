class MicrophoneAudioPacket {
  final List<int> data;
  final int sampleRate;
  final int channelCount;
  final int bytesPerSample;

  const MicrophoneAudioPacket({
    required this.data,
    required this.sampleRate,
    required this.channelCount,
    required this.bytesPerSample,
  });

  bool get isEmpty => data.isEmpty;

  bool get isMono => channelCount == 1;

  bool get is16Khz => sampleRate == 16000;

  bool get isPcm16 =>
      bytesPerSample == 2;

  MicrophoneAudioPacket copyWith({
    List<int>? data,
    int? sampleRate,
    int? channelCount,
    int? bytesPerSample,
  }) {
    return MicrophoneAudioPacket(
      data: data ?? this.data,
      sampleRate: sampleRate ?? this.sampleRate,
      channelCount: channelCount ?? this.channelCount,
      bytesPerSample: bytesPerSample ?? this.bytesPerSample,
    );
  }
}
