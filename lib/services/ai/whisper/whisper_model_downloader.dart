import 'dart:io';

import 'whisper_model_config.dart';

class WhisperModelDownloader {
  final WhisperModelConfig config;

  const WhisperModelDownloader({
    this.config = WhisperModelConfig.quranArabicBase,
  });

  Future<File> download({
    required Directory directory,
    void Function(int receivedBytes, int totalBytes)? onProgress,
  }) async {
    final modelDirectory = Directory(
      '${directory.path}/${config.modelName}',
    );

    if (!await modelDirectory.exists()) {
      await modelDirectory.create(recursive: true);
    }

    final modelFile = File(
      '${modelDirectory.path}/${config.modelFileName}',
    );

    if (await _isValidExistingFile(modelFile)) {
      return modelFile;
    }

    final temporaryFile = File(
      '${modelFile.path}.download',
    );

    final uri = Uri.parse(
      '${config.modelUrl}/resolve/main/${config.modelFileName}?download=true',
    );

    final client = HttpClient();

    try {
      final request = await client.getUrl(uri);

      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/octet-stream',
      );

      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'فشل تنزيل نموذج Whisper. HTTP ${response.statusCode}',
          uri: uri,
        );
      }

      final totalBytes = response.contentLength;
      var receivedBytes = 0;

      if (await temporaryFile.exists()) {
        await temporaryFile.delete();
      }

      final sink = temporaryFile.openWrite();

      try {
        await for (final chunk in response) {
          sink.add(chunk);
          receivedBytes += chunk.length;

          onProgress?.call(
            receivedBytes,
            totalBytes,
          );
        }

        await sink.flush();
      } finally {
        await sink.close();
      }

      if (!await _isValidExistingFile(temporaryFile)) {
        if (await temporaryFile.exists()) {
          await temporaryFile.delete();
        }

        throw const FileSystemException(
          'تم تنزيل ملف نموذج غير صالح أو غير مكتمل.',
        );
      }

      if (await modelFile.exists()) {
        await modelFile.delete();
      }

      await temporaryFile.rename(modelFile.path);

      return modelFile;
    } catch (_) {
      if (await temporaryFile.exists()) {
        await temporaryFile.delete();
      }

      rethrow;
    } finally {
      client.close(force: true);
    }
  }

  Future<bool> _isValidExistingFile(File file) async {
    if (!await file.exists()) {
      return false;
    }

    final size = await file.length();

    return size > 1024 * 1024;
  }
}
