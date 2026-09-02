import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';
import 'animated_section.dart';
import 'section_header.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface.withOpacity(0.4),
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 90),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnimatedSection(child: SectionHeader(index: "02", title: "Skills & Tools")),
              const SizedBox(height: 40),
              ...PortfolioData.skills.entries.toList().asMap().entries.map((entry) {
                final i = entry.key;
                final category = entry.value.key;
                final items = entry.value.value;
                return AnimatedSection(
                  delay: (i * 90).ms,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category, style: AppTheme.body(size: 13, color: AppColors.secondary, weight: FontWeight.w700)),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (int j = 0; j < items.length; j++)
                              _SkillChip(label: items[j], delay: (i * 90 + j * 45).ms),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String label;
  final Duration delay;
  const _SkillChip({required this.label, required this.delay});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        transform: Matrix4.identity()..scale(_hover ? 1.06 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _hover ? AppColors.primary.withOpacity(0.15) : AppColors.surfaceAlt,
          border: Border.all(color: _hover ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          widget.label,
          style: AppTheme.body(size: 14, color: _hover ? AppColors.textPrimary : AppColors.textSecondary, weight: FontWeight.w500),
        ),
      ),
    ).animate(delay: widget.delay).fadeIn(duration: 400.ms).scaleXY(begin: 0.85, end: 1, curve: Curves.easeOutBack);
  }
}
