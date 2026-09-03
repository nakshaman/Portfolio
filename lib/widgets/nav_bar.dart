import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';

/// A floating, pill-shaped nav bar (rounded, elevated, sits with margin from
/// the screen edges) — the same feel as awwwards-style portfolio sites.
class FloatingNavBar extends StatefulWidget {
  final Map<String, GlobalKey> sectionKeys;
  final void Function(GlobalKey key) onNavTap;

  const FloatingNavBar({super.key, required this.sectionKeys, required this.onNavTap});

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 18, pad, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 22, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.75),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => AppColors.heroGradient.createShader(bounds),
              child: Text("AK.", style: AppTheme.heading(size: 20, weight: FontWeight.w800)),
            ),
            const SizedBox(width: 6),
            if (!isMobile)
              Text("Aman Kumar", style: AppTheme.body(size: 13.5, color: AppColors.textSecondary, weight: FontWeight.w500)),
            const Spacer(),
            if (!isMobile) ..._desktopLinks() else _mobileMenuButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _desktopLinks() {
    final labels = ["About", "Skills", "Experience", "Projects"];
    return [
      for (final label in labels)
        _NavLink(
          label: label,
          onTap: () {
            final key = widget.sectionKeys[label];
            if (key != null) widget.onNavTap(key);
          },
        ),
      const SizedBox(width: 6),
      _PillCTA(
        label: "Email",
        onTap: () => launchUrl(Uri.parse("mailto:${PortfolioData.email}")),
      ),
      const SizedBox(width: 8),
      _PillCTA(
        label: "Contact",
        filled: true,
        onTap: () {
          final key = widget.sectionKeys["Contact"];
          if (key != null) widget.onNavTap(key);
        },
      ),
    ];
  }

  Widget _mobileMenuButton() {
    return IconButton(
      icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
      onPressed: () => _showMobileMenu(context),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  void _showMobileMenu(BuildContext context) {
    final labels = ["About", "Skills", "Experience", "Projects", "Contact"];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < labels.length; i++)
                  ListTile(
                    title: Center(
                      child: Text(labels[i], style: AppTheme.body(size: 18, color: AppColors.textPrimary)),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      final key = widget.sectionKeys[labels[i]];
                      if (key != null) widget.onNavTap(key);
                    },
                  ).animate().fadeIn(delay: (i * 60).ms).slideX(begin: 0.1, end: 0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          onTap: widget.onTap,
          child: Text(
            widget.label,
            style: AppTheme.body(
              size: 14,
              color: _hovering ? AppColors.textPrimary : AppColors.textSecondary,
              weight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _PillCTA extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  const _PillCTA({required this.label, required this.onTap, this.filled = false});

  @override
  State<_PillCTA> createState() => _PillCTAState();
}

class _PillCTAState extends State<_PillCTA> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            gradient: widget.filled ? AppColors.heroGradient : null,
            color: widget.filled ? null : (_hover ? AppColors.surfaceAlt : Colors.transparent),
            borderRadius: BorderRadius.circular(100),
            border: widget.filled ? null : Border.all(color: AppColors.border),
          ),
          child: Text(
            widget.label,
            style: AppTheme.body(
              size: 13,
              color: widget.filled ? Colors.white : AppColors.textPrimary,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
