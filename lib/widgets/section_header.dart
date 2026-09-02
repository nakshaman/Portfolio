import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String index;
  final String title;
  const SectionHeader({super.key, required this.index, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(index, style: AppTheme.mono(size: 16)),
        const SizedBox(width: 14),
        Container(width: 40, height: 1, color: AppColors.border),
        const SizedBox(width: 14),
        Text(title, style: AppTheme.heading(size: Responsive.isMobile(context) ? 26 : 32)),
      ],
    );
  }
}
