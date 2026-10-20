import 'package:flutter/material.dart';

/// A Kiwi-grade smooth number counter ticker.
/// Animates numbers with an ease-out curve, providing dynamic financial / metric feel.
class AnimatedCounter extends ImplicitlyAnimatedWidget {
  final num value;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int fractionDigits;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.fractionDigits = 0,
    super.duration = const Duration(milliseconds: 700),
    super.curve = Curves.easeOutCubic,
  });

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends AnimatedWidgetBaseState<AnimatedCounter> {
  Tween<num>? _numTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _numTween = visitor(
      _numTween,
      widget.value,
      (dynamic value) => Tween<num>(begin: (value as num?) ?? 0),
    ) as Tween<num>?;
  }

  @override
  Widget build(BuildContext context) {
    final current = _numTween?.evaluate(animation) ?? widget.value;
    final formattedNumber = widget.fractionDigits > 0
        ? current.toStringAsFixed(widget.fractionDigits)
        : current.toInt().toString();

    return Text(
      '${widget.prefix}$formattedNumber${widget.suffix}',
      style: widget.style,
    );
  }
}
