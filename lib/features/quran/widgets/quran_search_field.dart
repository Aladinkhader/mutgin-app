import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class QuranSearchField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final String hintText;

  const QuranSearchField({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'ابحث في القرآن الكريم',
  });

  @override
  State<QuranSearchField> createState() => _QuranSearchFieldState();
}

class _QuranSearchFieldState extends State<QuranSearchField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.surfaceSoft,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textDirection: TextDirection.rtl,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.body,
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
        onSubmitted: (_) {
          widget.onSubmitted?.call();
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintTextDirection: TextDirection.rtl,
          hintStyle: AppTextStyles.bodySecondary,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.gold,
          ),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  onPressed: _clear,
                  tooltip: 'مسح',
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}
