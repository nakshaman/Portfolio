import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Wraps [child] and plays a fade + slide-up entrance animation the first
/// time it scrolls into view. Used everywhere for the "reveal on scroll" feel.
class AnimatedSection extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double slideOffset;

  const AnimatedSection({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideOffset = 0.12,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection> {
  bool _visible = false;
  final Key _detectorKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_visible && info.visibleFraction > 0.12) {
          setState(() => _visible = true);
        }
      },
      child: _visible
          ? widget.child
              .animate(delay: widget.delay)
              .fadeIn(duration: 650.ms, curve: Curves.easeOut)
              .slideY(
                begin: widget.slideOffset,
                end: 0,
                duration: 650.ms,
                curve: Curves.easeOutCubic,
              )
          : Opacity(opacity: 0, child: widget.child),
    );
  }
}
