import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

class RecitationActionButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback? onPressed;

  const RecitationActionButton({
    super.key,
    required this.isListening,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 82,
        height: 82,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isListening
              ? AppColors.error
              : AppColors.emerald,
          boxShadow: isListening
              ? AppShadows.goldGlow
              : AppShadows.emeraldGlow,
        ),
        child: Icon(
          isListening
              ? Icons.stop_rounded
              : Icons.mic_rounded,
          color: AppColors.textPrimary,
          size: 34,
        ),
      ),
    );
  }
}
