import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:url_launcher/url_launcher.dart';
import '../data/data.dart';
import '../theme/app_theme.dart';

/// Default illustration if you don't add a local asset (see README).
/// Verified reachable at the time this was written — falls back to a
/// built-in illustration automatically if it's ever unreachable.
const String _heroLottieNetworkUrl = "https://assets4.lottiefiles.com/packages/lf20_l3sfdi9x.json";

/// If you download one of the "boy/man with laptop" animations you liked
/// and drop it at this path (see README), it's used instead of the network
/// one automatically — no code changes needed.
const String _heroLottieAssetPath = "assets/animations/coding.json";

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
      if (mounted) setState(() => _roleIndex = (_roleIndex + 1) % PortfolioData.roles.length);
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
    final screenHeight = MediaQuery.of(context).size.height;
    final cardMinHeight = isMobile ? screenHeight * 0.86 : (isTablet ? 640.0 : 700.0);
    final illustrationSize = isMobile ? 140.0 : (isTablet ? 170.0 : 190.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 22, pad, 40),
      // ConstrainedBox with only minHeight (not a fixed height) — this lets
      // the card grow taller than cardMinHeight if the content needs more
      // room (long text on a short/narrow window), instead of clipping it.
      // Content below no longer uses Spacer (which needs a bounded height
      // and would crash here), so this is safe inside a scroll view.
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: cardMinHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isMobile ? 28 : 40),
          child: Container(
            decoration: const BoxDecoration(color: AppColors.surface),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                // Ambient glow blobs, clipped to the card's rounded corners.
                Positioned(
                  top: -100,
                  right: -80,
                  child: _GlowOrb(color: AppColors.primary, size: isMobile ? 240 : 420),
                ),
                Positioned(
                  bottom: -80,
                  left: -100,
                  child: _GlowOrb(color: AppColors.secondary, size: isMobile ? 220 : 380, delay: 900),
                ),
                Positioned(
                  top: 60,
                  left: -60,
                  child: _GlowOrb(color: AppColors.accent, size: isMobile ? 140 : 220, delay: 1500),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 56, vertical: isMobile ? 40 : 56),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _HeroIllustration(size: illustrationSize)
                          .animate()

                          .fadeIn(duration: 700.ms)
                          .scaleXY(begin: 0.85, end: 1, curve: Curves.easeOutBack),

                      const SizedBox(height: 28),

                      Text(
                        "Hi, I'm",
                        textAlign: TextAlign.center,
                        style: AppTheme.heading(size: isMobile ? 18 : 22, weight: FontWeight.w500)
                            .copyWith(color: AppColors.textSecondary),
                      ).animate().fadeIn(delay: 150.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 8),

                      ShaderMask(
                        shaderCallback: (bounds) => AppColors.heroGradient.createShader(bounds),
                        child: Text(
                          PortfolioData.name,
                          textAlign: TextAlign.center,
                          style: AppTheme.heading(
                            size: isMobile ? 38 : (isTablet ? 54 : 64),
                            weight: FontWeight.w800,
                          ),
                        ),
                      ).animate().fadeIn(delay: 280.ms, duration: 600.ms).slideY(begin: 0.25, end: 0),

                      const SizedBox(height: 16),

                      // Fixed-alignment role switcher — layoutBuilder centers
                      // every child on the same baseline so incoming/outgoing
                      // text never overlaps unevenly.
                      SizedBox(
                        height: isMobile ? 30 : 38,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 420),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          layoutBuilder: (currentChild, previousChildren) => Stack(
                            alignment: Alignment.center,
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
                              Icon(Icons.bolt_rounded, color: AppColors.secondary, size: isMobile ? 16 : 22),
                              const SizedBox(width: 8),
                              Text(
                                PortfolioData.roles[_roleIndex],
                                style: AppTheme.heading(size: isMobile ? 16 : 22, weight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Text(
                          PortfolioData.summary,
                          textAlign: TextAlign.center,
                          style: AppTheme.body(size: isMobile ? 14 : 16),
                        ),
                      ).animate().fadeIn(delay: 450.ms, duration: 600.ms),

                      const SizedBox(height: 32),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          _PrimaryButton(label: "View Projects", onTap: widget.onProjectsTap),
                          _SecondaryButton(label: "Get In Touch", onTap: widget.onContactTap),
                          _IconLink(icon: Icons.code_rounded, url: PortfolioData.githubUrl),
                          _IconLink(icon: Icons.business_center_rounded, url: PortfolioData.linkedinUrl),
                        ],
                      ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),

                      SizedBox(height: isMobile ? 36 : 48),

                      // Bottom scroll-cue pill, echoing the reference design.
                      _ScrollCuePill(onTap: widget.onProjectsTap)
                          .animate()
                          .fadeIn(delay: 750.ms, duration: 500.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrollCuePill extends StatefulWidget {
  final VoidCallback onTap;
  const _ScrollCuePill({required this.onTap});

  @override
  State<_ScrollCuePill> createState() => _ScrollCuePillState();
}

class _ScrollCuePillState extends State<_ScrollCuePill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            color: _hover ? AppColors.surfaceAlt : AppColors.surfaceAlt.withOpacity(0.6),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.border),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text(
                isMobile ? "Flutter · Firebase · Clean Code" : "Flutter  →  Firebase  →  Clean Code",
                style: AppTheme.mono(size: 11.5, color: AppColors.textSecondary),
              ),
              Text("·", style: AppTheme.mono(size: 11.5, color: AppColors.textSecondary)),
              Text("See more", style: AppTheme.mono(size: 11.5)),
              Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: AppColors.secondary)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: 0, end: 4, duration: 700.ms, curve: Curves.easeInOut),
            ],
          ),
        ),
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

/// Loads the local asset first (if you added your preferred animation — see
/// README), falls back to the network URL, and finally to a small built-in
/// illustration if neither is available. The hero never breaks.
class _HeroIllustration extends StatelessWidget {
  final double size;
  const _HeroIllustration({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FutureBuilder<bool>(
        future: _assetExists(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox.shrink();
          }
          final useAsset = snapshot.data ?? false;
          return (useAsset
                  ? lottie.Lottie.asset(
                      _heroLottieAssetPath,
                      fit: BoxFit.contain,
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) => _NetworkOrFallback(size: size),
                    )
                  : _NetworkOrFallback(size: size))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: 0, end: -12, duration: 2600.ms, curve: Curves.easeInOut);
        },
      ),
    );
  }

  Future<bool> _assetExists(BuildContext context) async {
    try {
      await DefaultAssetBundle.of(context).load(_heroLottieAssetPath);
      return true;
    } catch (_) {
      return false;
    }
  }
}

class _NetworkOrFallback extends StatelessWidget {
  final double size;
  const _NetworkOrFallback({required this.size});

  @override
  Widget build(BuildContext context) {
    return lottie.Lottie.network(
      _heroLottieNetworkUrl,
      fit: BoxFit.contain,
      repeat: true,
      errorBuilder: (context, error, stackTrace) => _DeveloperIllustration(size: size),
      frameBuilder: (context, child, composition) {
        if (composition == null) return _DeveloperIllustration(size: size);
        return child;
      },
    );
  }
}

/// A dependency-free illustration used if neither the local asset nor the
/// network animation is available. Keeps the hero from ever looking broken.
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
              color: AppColors.surfaceAlt,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          decoration: BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hover
                ? [BoxShadow(color: AppColors.primary.withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 8))]
                : [],
          ),
          child: Text(widget.label, style: AppTheme.body(size: 14.5, color: Colors.white, weight: FontWeight.w600)),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: _hover ? AppColors.secondary : AppColors.border),
            borderRadius: BorderRadius.circular(12),
            color: _hover ? AppColors.surfaceAlt : Colors.transparent,
          ),
          child: Text(widget.label, style: AppTheme.body(size: 14.5, color: AppColors.textPrimary, weight: FontWeight.w600)),
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _hover ? AppColors.secondary : AppColors.border),
            color: _hover ? AppColors.surfaceAlt : Colors.transparent,
          ),
          child: Icon(widget.icon, color: AppColors.textPrimary, size: 19),
        ),
      ),
    );
  }
}
