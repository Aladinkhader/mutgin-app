import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/ayah.dart';
import '../../../services/recitation/recitation_session_state.dart';
import '../controllers/recitation_controller_factory.dart';
import '../controllers/recitation_session_controller.dart';
import '../widgets/recitation_action_button.dart';
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
  late final RecitationSessionController _controller;

  bool _showText = true;

  @override
  void initState() {
    super.initState();

    _controller =
        RecitationControllerFactory.createSessionController();

    _controller.addListener(_onControllerChanged);
    _controller.start(widget.ayah);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startListening() {
    _controller.startListening();
  }

  void _stopListening() {
    _controller.reset();
    _controller.start(widget.ayah);
  }

  void _resetSession() {
    _controller.reset();
    _controller.start(widget.ayah);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final isListening =
        state == RecitationSessionState.listening;

    final statusResult = _buildStatusResult();

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
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
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
                        result: statusResult,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RecitationSessionPanel(
                        currentAyah: _controller.currentAyah,
                        state: state,
                        accuracy: _controller.accuracy,
                        errors: _controller.errors,
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

  dynamic _buildStatusResult() {
    final current = _controller.currentAyah;

    if (current == null) {
      return const RecitationStatusView(
        result: null,
      );
    }

    return _StatusResult(
      state: _controller.state,
      surahNumber: current.surahNumber,
      ayahNumber: current.ayahNumber,
      expectedText: current.text,
    );
  }
}

class _StatusResult {
  final RecitationSessionState state;
  final int surahNumber;
  final int ayahNumber;
  final String expectedText;

  const _StatusResult({
    required this.state,
    required this.surahNumber,
    required this.ayahNumber,
    required this.expectedText,
  });
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
        borderRadius: BorderRadius.circular(20),
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
