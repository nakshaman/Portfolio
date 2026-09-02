import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final Map<String, GlobalKey> sectionKeys;
  final void Function(GlobalKey key) onNavTap;

  const NavBar({super.key, required this.sectionKeys, required this.onNavTap});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return AppBar(
      backgroundColor: AppColors.background.withOpacity(0.85),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleSpacing: Responsive.horizontalPadding(context),
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => AppColors.heroGradient.createShader(bounds),
            child: Text("AK.", style: AppTheme.heading(size: 24, weight: FontWeight.w800)),
          ),
        ],
      ),
      actions: [
        if (!isMobile) ..._desktopLinks(context) else _mobileMenuButton(),
        SizedBox(width: Responsive.horizontalPadding(context) - (isMobile ? 12 : 0)),
      ],
    );
  }

  List<Widget> _desktopLinks(BuildContext context) {
    final labels = ["About", "Skills", "Experience", "Projects", "Contact"];
    return [
      for (final label in labels)
        _NavLink(
          label: label,
          onTap: () {
            final key = widget.sectionKeys[label];
            if (key != null) widget.onNavTap(key);
          },
        ),
      const SizedBox(width: 8),
    ];
  }

  Widget _mobileMenuButton() {
    return IconButton(
      icon: Icon(_menuOpen ? Icons.close : Icons.menu, color: AppColors.textPrimary),
      onPressed: () => _showMobileMenu(context),
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
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTheme.body(
                  size: 15,
                  color: _hovering ? AppColors.textPrimary : AppColors.textSecondary,
                  weight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 2,
                width: _hovering ? 18 : 0,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
