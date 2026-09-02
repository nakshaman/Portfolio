import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:url_launcher/url_launcher.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';

/// A coding/developer-themed Lottie animation. If it ever fails to load
/// (offline, blocked network, dead link), [_DeveloperIllustration] is shown
/// instead — see the errorBuilder below.
const String _heroLottieUrl = "https://assets4.lottiefiles.com/packages/lf20_l3sfdi9x.json";

class HeroSection extends StatefulWidget {
  final VoidCallback onProjectsTap;
  final VoidCallback onContactTap;
  const HeroSection({super.key, required this.onProjectsTap, required this.onContactTap});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _roleIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2, milliseconds: 400), (_) {
      setState(() => _roleIndex = (_roleIndex + 1) % PortfolioData.roles.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final pad = Responsive.horizontalPadding(context);
    // Full first-viewport height (minus the nav bar) so the hero never
    // looks like it "cuts off" halfway down the screen.
    final viewportHeight = MediaQuery.of(context).size.height - 76;
    final heroHeight = viewportHeight < 620 ? 620.0 : viewportHeight;

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(30),
            color: AppColors.surface.withOpacity(0.6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 900.ms).then().fadeOut(duration: 900.ms),
              const SizedBox(width: 8),
              Text("Available for opportunities", style: AppTheme.mono(size: 12.5)),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

        const SizedBox(height: 26),

        Text(
          "Hi, I'm",
          style: AppTheme.heading(size: isMobile ? 22 : 26, weight: FontWeight.w500)
              .copyWith(color: AppColors.textSecondary),
        ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),

        const SizedBox(height: 6),

        ShaderMask(
          shaderCallback: (bounds) => AppColors.heroGradient.createShader(bounds),
          child: Text(
            PortfolioData.name,
            style: AppTheme.heading(size: isMobile ? 40 : (isTablet ? 56 : 68), weight: FontWeight.w800),
          ),
        ).animate().fadeIn(delay: 280.ms, duration: 600.ms).slideY(begin: 0.25, end: 0),

        const SizedBox(height: 18),

        // Fixed-alignment role switcher: layoutBuilder pins every child to
        // the left so incoming/outgoing text never overlaps vertically.
        SizedBox(
          height: isMobile ? 30 : 40,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.centerLeft,
              children: [...previousChildren, if (currentChild != null) currentChild],
            ),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(anim),
                child: child,
              ),
            ),
            child: Row(
              key: ValueKey(_roleIndex),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, color: AppColors.secondary, size: isMobile ? 18 : 24),
                const SizedBox(width: 8),
                Text(
                  PortfolioData.roles[_roleIndex],
                  style: AppTheme.heading(size: isMobile ? 18 : 26, weight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 26),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(PortfolioData.summary, style: AppTheme.body(size: isMobile ? 15 : 17)),
        ).animate().fadeIn(delay: 450.ms, duration: 600.ms),

        const SizedBox(height: 36),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _PrimaryButton(label: "View Projects", onTap: widget.onProjectsTap),
            _SecondaryButton(label: "Get In Touch", onTap: widget.onContactTap),
            _IconLink(icon: Icons.code_rounded, url: PortfolioData.githubUrl),
            _IconLink(icon: Icons.business_center_rounded, url: PortfolioData.linkedinUrl),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
      ],
    );

    final illustration = _HeroIllustration(size: isMobile ? 240 : (isTablet ? 320 : 420));

    return SizedBox(
      width: double.infinity,
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient animated glow blobs — sized to the full hero, not just
          // the top slice, so the color never "runs out" partway down.
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(color: AppColors.primary, size: isMobile ? 220 : 380),
          ),
          Positioned(
            bottom: -60,
            left: -80,
            child: _GlowOrb(color: AppColors.secondary, size: isMobile ? 200 : 340, delay: 900),
          ),
          Positioned(
            bottom: 40,
            right: isMobile ? -40 : 60,
            child: _GlowOrb(color: AppColors.accent, size: isMobile ? 160 : 260, delay: 1500),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: isMobile ? 40 : 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
                child: isMobile
                    ? SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            illustration.animate().fadeIn(duration: 700.ms).scaleXY(begin: 0.9, end: 1),
                            const SizedBox(height: 12),
                            textColumn,
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 6, child: textColumn),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: illustration.animate().fadeIn(duration: 800.ms, delay: 200.ms).scaleXY(begin: 0.88, end: 1, curve: Curves.easeOutBack),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wraps the Lottie animation with a floating "bob" motion and a reliable
/// fallback illustration if the network animation can't be reached.
class _HeroIllustration extends StatelessWidget {
  final double size;
  const _HeroIllustration({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: lottie.Lottie.network(
        _heroLottieUrl,
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (context, error, stackTrace) => _DeveloperIllustration(size: size),
        frameBuilder: (context, child, composition) {
          if (composition == null) {
            return _DeveloperIllustration(size: size);
          }
          return child;
        },
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -14, duration: 2600.ms, curve: Curves.easeInOut);
  }
}

/// A dependency-free illustration used if the Lottie network asset fails to
/// load (e.g. offline). Keeps the hero from ever looking broken.
class _DeveloperIllustration extends StatelessWidget {
  final double size;
  const _DeveloperIllustration({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [AppColors.primary.withOpacity(0.25), Colors.transparent]),
            ),
          ),
          Container(
            width: size * 0.62,
            height: size * 0.44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    height: 6,
                    width: (size * 0.62 - 28) * (i == 1 ? 0.7 : 0.9),
                    decoration: BoxDecoration(
                      color: i == 0 ? AppColors.secondary : AppColors.primary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(duration: (700 + i * 200).ms)
                    .then(delay: 600.ms)
                    .fadeOut(duration: (700 + i * 200).ms);
              }),
            ),
          ),
          Positioned(
            bottom: size * 0.12,
            child: Icon(Icons.person_rounded, size: size * 0.22, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final int delay;
  const _GlowOrb({required this.color, required this.size, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color.withOpacity(0.35), color.withOpacity(0.0)]),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 1, end: 1.15, duration: 3800.ms, delay: delay.ms, curve: Curves.easeInOut)
        .then()
        .move(begin: Offset.zero, end: const Offset(10, 14), duration: 3800.ms, curve: Curves.easeInOut);
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_hover ? 1.03 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hover
                ? [BoxShadow(color: AppColors.primary.withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 8))]
                : [],
          ),
          child: Text(widget.label, style: AppTheme.body(size: 15, color: Colors.white, weight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: _hover ? AppColors.secondary : AppColors.border),
            borderRadius: BorderRadius.circular(12),
            color: _hover ? AppColors.surfaceAlt : Colors.transparent,
          ),
          child: Text(widget.label, style: AppTheme.body(size: 15, color: AppColors.textPrimary, weight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _IconLink extends StatefulWidget {
  final IconData icon;
  final String url;
  const _IconLink({required this.icon, required this.url});

  @override
  State<_IconLink> createState() => _IconLinkState();
}

class _IconLinkState extends State<_IconLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _hover ? AppColors.secondary : AppColors.border),
            color: _hover ? AppColors.surfaceAlt : Colors.transparent,
          ),
          child: Icon(widget.icon, color: AppColors.textPrimary, size: 20),
        ),
      ),
    );
  }
}
