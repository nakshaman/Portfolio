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
    final isTablet = Responsive.isTablet(context);
    // 2 columns on phones, 4 on everything wider (fits all 4 stats in one row).
    final gridColumns = isMobile ? 2 : 4;
    // Wide desktop cards would look oversized/tall at aspect 1.35 with 4
    // columns of ~280px+ width each — flatten them out as the grid widens.
    final gridAspectRatio = isMobile ? 1.5 : (isTablet ? 1.9 : 2.5);

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

              // Education + Highlights — always full width, always first.
              AnimatedSection(
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

              const SizedBox(height: 36),

              // Stats — always below Education/Highlights, always a proper grid.
              AnimatedSection(
                delay: 150.ms,
                child: GridView.count(
                  crossAxisCount: gridColumns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: gridAspectRatio,
                  children: const [
                    _StatCard(value: "400+", label: "Problems Solved"),
                    _StatCard(value: "2+", label: "Live Projects"),
                    _StatCard(value: "5", label: "State Mgmt Tools"),
                    _StatCard(value: "SIH", label: "2024 Participant"),
                  ],
                ),
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
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
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
                style: AppTheme.heading(size: 24, weight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.body(size: 12, weight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
