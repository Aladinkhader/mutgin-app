import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../models/recitation_result.dart';
import '../controllers/recitation_screen_controller.dart';
import 'recitation_audio_controls.dart';
import 'recitation_audio_result_view.dart';
import 'recitation_microphone_error.dart';
import 'recitation_recording_indicator.dart';

class RecitationScreenAudioSection extends StatelessWidget {
  final RecitationScreenController controller;

  const RecitationScreenAudioSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RecitationMicrophoneError(
              message: controller.microphoneError,
            ),
            if (controller.microphoneError != null)
              const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.center,
              child: RecitationRecordingIndicator(
                isRecording: controller.isRecording,
                isProcessing: controller.isProcessing,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            RecitationAudioControls(
              isRecording: controller.isRecording,
              isProcessing: controller.isProcessing,
              onStart: controller.start,
              onStop: controller.isProcessing
                  ? null
                  : controller.stop,
              onCancel: controller.cancel,
            ),
            if (controller.result.status !=
                    RecitationStatus.idle &&
                controller.result.status !=
                    RecitationStatus.listening) ...[
              const SizedBox(height: AppSpacing.md),
              RecitationAudioResultView(
                result: controller.result,
              ),
            ],
          ],
        );
      },
    );
  }
}
