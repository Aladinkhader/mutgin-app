import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';
import '../../../models/recitation_result.dart';
import '../../../services/recitation/recitation_session_state.dart';
import '../controllers/recitation_screen_controller.dart';
import '../controllers/recitation_controller_factory.dart';
import '../controllers/recitation_session_controller.dart';
import '../widgets/recitation_audio_section.dart';
import '../widgets/recitation_session_actions.dart';
import '../widgets/recitation_session_panel.dart';
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
  late final RecitationSessionController _sessionController;
  late final RecitationScreenController _audioController;

  bool _showText = true;

  @override
  void initState() {
    super.initState();

    _sessionController =
        RecitationControllerFactory.createSessionController();

    _audioController = RecitationScreenController();

    _sessionController.addListener(_onChanged);
    _audioController.addListener(_onChanged);

    _sessionController.start(widget.ayah);
    _audioController.setAyah(widget.ayah);
  }

  void _onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startListening() {
    _sessionController.startListening();
    _audioController.start();
  }

  Future<void> _stopListening() async {
    await _audioController.stop();

    if (!mounted) return;

    final result = _audioController.result;

    if (result.status == RecitationStatus.correct ||
        result.status == RecitationStatus.mistake) {
      return;
    }

    _sessionController.reset();
    _sessionController.start(widget.ayah);
  }

  void _resetSession() {
    _audioController.cancel();
    _sessionController.reset();
    _sessionController.start(widget.ayah);
  }

  RecitationResult _buildStatusResult() {
    final currentAyah = _sessionController.currentAyah;

    if (currentAyah == null) {
      return const RecitationResult(
        status: RecitationStatus.idle,
      );
    }

    final result = _audioController.result;

    if (result.status != RecitationStatus.idle) {
      return result;
    }

    final status = _sessionController.state;

    final recitationStatus = switch (status) {
      RecitationSessionState.idle => RecitationStatus.idle,
      RecitationSessionState.preparing => RecitationStatus.processing,
      RecitationSessionState.listening => RecitationStatus.listening,
      RecitationSessionState.analyzing => RecitationStatus.processing,
      RecitationSessionState.completed => RecitationStatus.completed,
      RecitationSessionState.error => RecitationStatus.mistake,
    };

    return RecitationResult(
      status: recitationStatus,
      surahNumber: currentAyah.surahNumber,
      ayahNumber: currentAyah.ayahNumber,
      expectedText: currentAyah.text,
      confidence: 0.0,
    );
  }

  @override
  void dispose() {
    _sessionController.removeListener(_onChanged);
    _audioController.removeListener(_onChanged);

    _sessionController.dispose();
    _audioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _sessionController.state;
    final isListening =
        state == RecitationSessionState.listening ||
        _audioController.isRecording;

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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'الآية ${widget.ayah.ayahNumber}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _AyahCard(
                        ayah: widget.ayah,
                        isActive: isListening,
                        showText: _showText,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      RecitationStatusView(
                        result: _buildStatusResult(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RecitationScreenAudioSection(
                        controller: _audioController,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RecitationSessionPanel(
                        currentAyah: _sessionController.currentAyah,
                        state: state,
                        accuracy: _sessionController.accuracy,
                        errors: _sessionController.errors,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              RecitationSessionActions(
                state: state,
                onStart: _startListening,
                onStop: _stopListening,
                onReset: _resetSession,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  final Ayah ayah;
  final bool isActive;
  final bool showText;

  const _AyahCard({
    required this.ayah,
    required this.isActive,
    required this.showText,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.emerald.withValues(alpha: 0.14)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isActive
              ? AppColors.gold.withValues(alpha: 0.45)
              : AppColors.surfaceSoft,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${ayah.ayahNumber}',
              style: AppTextStyles.gold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            showText ? ayah.text : 'أكمل التسميع من حفظك',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: showText ? 23 : 18,
              height: showText ? 2 : 1.6,
              color: showText
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
