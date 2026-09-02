import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';
import 'animated_section.dart';
import 'section_header.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);

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
              const AnimatedSection(child: SectionHeader(index: "04", title: "Projects")),
              const SizedBox(height: 40),
              isMobile
                  ? Column(
                      children: [
                        for (int i = 0; i < PortfolioData.projects.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: AnimatedSection(
                              delay: (i * 120).ms,
                              child: _ProjectCard(project: PortfolioData.projects[i]),
                            ),
                          ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < PortfolioData.projects.length; i++) ...[
                          Expanded(
                            child: AnimatedSection(
                              delay: (i * 150).ms,
                              child: _ProjectCard(project: PortfolioData.projects[i]),
                            ),
                          ),
                          if (i != PortfolioData.projects.length - 1) const SizedBox(width: 28),
                        ],
                      ],
                    ),
              const SizedBox(height: 44),
              AnimatedSection(
                delay: 200.ms,
                child: Text(
                  "More on GitHub",
                  style: AppTheme.body(size: 13, color: AppColors.secondary, weight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 18),
              isMobile
                  ? Column(
                      children: [
                        for (int i = 0; i < PortfolioData.miniProjects.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: AnimatedSection(
                              delay: (i * 100).ms,
                              child: _MiniProjectCard(project: PortfolioData.miniProjects[i]),
                            ),
                          ),
                      ],
                    )
                  : Row(
                      children: [
                        for (int i = 0; i < PortfolioData.miniProjects.length; i++) ...[
                          Expanded(
                            child: AnimatedSection(
                              delay: (i * 100).ms,
                              child: _MiniProjectCard(project: PortfolioData.miniProjects[i]),
                            ),
                          ),
                          if (i != PortfolioData.miniProjects.length - 1) const SizedBox(width: 24),
                        ],
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniProjectCard extends StatefulWidget {
  final ProjectItem project;
  const _MiniProjectCard({required this.project});

  @override
  State<_MiniProjectCard> createState() => _MiniProjectCardState();
}

class _MiniProjectCardState extends State<_MiniProjectCard> {
  bool _hover = false;

  IconData get _icon {
    switch (widget.project.icon) {
      case "place":
        return Icons.place_rounded;
      case "cloud":
        return Icons.cloud_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(p.repoUrl), mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _hover ? AppColors.secondary.withOpacity(0.6) : AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, style: AppTheme.body(size: 15.5, color: AppColors.textPrimary, weight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(p.points.first, style: AppTheme.body(size: 13)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final t in p.tech)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceAlt,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(t, style: AppTheme.body(size: 11, color: AppColors.textSecondary)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_outward_rounded, size: 16, color: _hover ? AppColors.secondary : AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectItem project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hover = false;

  IconData get _icon {
    switch (widget.project.icon) {
      case "camera":
        return Icons.camera_alt_rounded;
      case "chat":
        return Icons.chat_bubble_rounded;
      default:
        return Icons.rocket_launch_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hover ? -8.0 : 0.0),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _hover ? AppColors.primary.withOpacity(0.6) : AppColors.border),
          boxShadow: _hover
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 30, offset: const Offset(0, 14))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Text(p.date, style: AppTheme.mono(size: 12.5)),
              ],
            ),
            const SizedBox(height: 20),
            Text(p.title, style: AppTheme.heading(size: 22, weight: FontWeight.w700)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in p.tech)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(t, style: AppTheme.body(size: 12, color: AppColors.secondary, weight: FontWeight.w500)),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            for (final point in p.points.take(4))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(point, style: AppTheme.body(size: 13.5))),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse(p.repoUrl), mode: LaunchMode.externalApplication),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("View on GitHub", style: AppTheme.body(size: 14, color: AppColors.textPrimary, weight: FontWeight.w600)),
                  const SizedBox(width: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..translate(_hover ? 4.0 : 0.0, 0.0),
                    child: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
