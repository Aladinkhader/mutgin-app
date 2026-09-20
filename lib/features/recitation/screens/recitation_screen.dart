import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../widgets/ayah_recitation_card.dart';
import '../widgets/recitation_action_button.dart';
import '../widgets/recitation_status_view.dart';

class RecitationScreen extends StatefulWidget {
  final Ayah ayah;

  const RecitationScreen({
    super.key,
    required this.ayah,
  });

  @override
  State<RecitationScreen> createState() => _RecitationScreenState();
}

class _RecitationScreenState extends State<RecitationScreen> {
  bool _isListening = false;
  bool _showText = true;

  RecitationResult get _statusResult {
    return RecitationResult(
      status: _isListening
          ? RecitationStatus.listening
          : RecitationStatus.idle,
      surahNumber: widget.ayah.surahNumber,
      ayahNumber: widget.ayah.ayahNumber,
      expectedText: widget.ayah.text,
    );
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التسميع'),
        actions: [
          IconButton(
            tooltip: _showText ? 'إخفاء الآية' : 'إظهار الآية',
            onPressed: () {
              setState(() {
                _showText = !_showText;
              });
            },
            icon: Icon(
              _showText
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'الآية ${widget.ayah.ayahNumber}',
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AyahRecitationCard(
                        ayah: widget.ayah,
                        isActive: _isListening,
                        showText: _showText,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      RecitationStatusView(
                        result: _statusResult,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _isListening
                    ? 'متقن يستمع إلى تلاوتك...'
                    : 'اضغط على الميكروفون لبدء التسميع',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.md),
              RecitationActionButton(
                isListening: _isListening,
                onPressed: _toggleListening,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
