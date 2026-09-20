import 'dart:io';

import 'whisper_model_config.dart';

class WhisperModelDownloader {
  final WhisperModelConfig config;

  const WhisperModelDownloader({
    this.config = WhisperModelConfig.quranArabicBase,
  });

  Future<File> download({
    required Directory directory,
  }) async {
    final modelDirectory = Directory(
      '${directory.path}/${config.modelName}',
    );

    if (!await modelDirectory.exists()) {
      await modelDirectory.create(
        recursive: true,
      );
    }

    final markerFile = File(
      '${modelDirectory.path}/model.info',
    );

    if (await markerFile.exists()) {
      return markerFile;
    }

    await markerFile.writeAsString(
      [
        'name=${config.modelName}',
        'url=${config.modelUrl}',
        'sample_rate=${config.sampleRate}',
        'channels=${config.channels}',
      ].join('\n'),
    );

    return markerFile;
  }
}
