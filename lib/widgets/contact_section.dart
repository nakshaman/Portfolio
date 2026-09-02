import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';
import 'animated_section.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.horizontalPadding(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: AnimatedSection(
            child: Column(
              children: [
                Text("06", style: AppTheme.mono(size: 15)),
                const SizedBox(height: 18),
                Text(
                  "Let's Build Something Great",
                  textAlign: TextAlign.center,
                  style: AppTheme.heading(size: isMobile ? 30 : 44, weight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                Text(
                  "I'm open to Flutter development roles and freelance projects. "
                  "Drop a message and I'll get back to you soon.",
                  textAlign: TextAlign.center,
                  style: AppTheme.body(size: 16),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _ContactButton(
                      icon: Icons.mail_rounded,
                      label: PortfolioData.email,
                      onTap: () => launchUrl(Uri.parse("mailto:${PortfolioData.email}")),
                      filled: true,
                    ),
                    _ContactButton(
                      icon: Icons.call_rounded,
                      label: PortfolioData.phone,
                      onTap: () => launchUrl(Uri.parse("tel:${PortfolioData.phone.replaceAll(' ', '')}")),
                    ),
                    _ContactButton(
                      icon: Icons.location_on_rounded,
                      label: PortfolioData.location,
                      onTap: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;
  const _ContactButton({required this.icon, required this.label, required this.onTap, this.filled = false});

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_hover && widget.onTap != null ? 1.04 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.filled ? AppColors.heroGradient : null,
            color: widget.filled ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: widget.filled ? null : Border.all(color: _hover ? AppColors.secondary : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: widget.filled ? Colors.white : AppColors.secondary),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: AppTheme.body(size: 14.5, color: widget.filled ? Colors.white : AppColors.textPrimary, weight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
