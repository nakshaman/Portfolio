import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';
import 'animated_section.dart';
import 'section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.horizontalPadding(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 90),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnimatedSection(child: SectionHeader(index: "01", title: "About Me")),
              const SizedBox(height: 36),
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: AnimatedSection(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Education",
                            style: AppTheme.body(size: 13, color: AppColors.secondary, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(PortfolioData.education, style: AppTheme.body(size: 16, color: AppColors.textPrimary)),
                          const SizedBox(height: 28),
                          Text(
                            "Highlights",
                            style: AppTheme.body(size: 13, color: AppColors.secondary, weight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          for (final item in PortfolioData.additional)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(item, style: AppTheme.body(size: 15.5))),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: isMobile ? 0 : 60, height: isMobile ? 40 : 0),
                  Expanded(
                    flex: 2,
                    child: AnimatedSection(
                      delay: 150.ms,
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: const [
                          _StatCard(value: "400+", label: "Problems Solved"),
                          _StatCard(value: "2+", label: "Live Projects"),
                          _StatCard(value: "5", label: "State Mgmt Tools"),
                          _StatCard(value: "SIH", label: "2024 Participant"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String value;
  final String label;
  const _StatCard({required this.value, required this.label});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        height: 118,
        padding: const EdgeInsets.all(18),
        transform: Matrix4.identity()..translate(0.0, _hover ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hover ? AppColors.primary.withOpacity(0.5) : AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.heroGradient.createShader(bounds),
              child: Text(
                widget.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.heading(size: 26, weight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.body(size: 12.5, weight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
