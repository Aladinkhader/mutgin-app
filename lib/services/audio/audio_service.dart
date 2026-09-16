abstract class AudioService {
  Future<bool> requestPermission();

  Future<void> startListening();

  Future<void> stopListening();

  Stream<List<int>> get audioStream;

  bool get isListening;
}
