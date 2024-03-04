import 'package:flutter/material.dart';
import 'dart:math' as math;

const Size _kDefaultSize = Size.square(9.0);
const EdgeInsets _kDefaultSpacing = EdgeInsets.all(6.0);
const ShapeBorder _kDefaultShape = CircleBorder();

class DotsIndicator extends StatelessWidget {
  final int dotsCount;
  final int position;
  final Axis axis;
  final bool reversed;
  final Function(int)? onTap;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  final Color color;
  final List<Color> colors;
  final Color? activeColor;
  final List<Color> activeColors;
  final Size size;
  final List<Size> sizes;
  final Size activeSize;
  final List<Size> activeSizes;
  final ShapeBorder shape;
  final List<ShapeBorder> shapes;
  final ShapeBorder activeShape;
  final List<ShapeBorder> activeShapes;
  final EdgeInsets spacing;

  const DotsIndicator({
    super.key,
    required this.dotsCount,
    this.position = 0,
    this.axis = Axis.horizontal,
    this.reversed = false,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
    this.color = Colors.grey,
    this.colors = const [],
    this.activeColor,
    this.activeColors = const [],
    this.size = _kDefaultSize,
    this.sizes = const [],
    this.activeSize = _kDefaultSize,
    this.activeSizes = const [],
    this.shape = _kDefaultShape,
    this.shapes = const [],
    this.activeShape = _kDefaultShape,
    this.activeShapes = const [],
    this.spacing = _kDefaultSpacing,
  })  : assert(dotsCount > 0, 'dotsCount must be superior to zero'),
        assert(position >= 0, 'position must be superior or equals to zero'),
        assert(
          position < dotsCount,
          "position must be less than dotsCount",
        ),
        assert(
          activeColors.length == 0 || activeColors.length == dotsCount,
          "should be empty or have same length as dots count",
        ),
        assert(
          sizes.length == 0 || sizes.length == dotsCount,
          "should be empty or have same length as dots count",
        ),
        assert(
          activeSizes.length == 0 || activeSizes.length == dotsCount,
          "should be empty or have same length as dots count",
        ),
        assert(
          shapes.length == 0 || shapes.length == dotsCount,
          "should be empty or have same length as dots count",
        ),
        assert(
          activeShapes.length == 0 || activeShapes.length == dotsCount,
          "should be empty or have same length as dots count",
        );

  Widget _wrapInkwell(Widget dot, int index) {
    return InkWell(
      customBorder: position == index
          ? activeShapes.elementAtOrNull(index) ?? activeShape
          : shapes.elementAtOrNull(index) ?? shape,
      onTap: () => onTap!(index),
      child: dot,
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    final double lerpValue = math.min(1, (position - index).abs()).toDouble();

    final size = Size.lerp(
      activeSizes.elementAtOrNull(index) ?? activeSize,
      sizes.elementAtOrNull(index) ?? this.size,
      lerpValue,
    )!;

    final dot = Container(
      width: size.width,
      height: size.height,
      margin: spacing,
      decoration: ShapeDecoration(
        color: Color.lerp(
          activeColors.elementAtOrNull(index) ??
              activeColor ??
              Theme.of(context).colorScheme.primary,
          colors.elementAtOrNull(index) ?? color,
          lerpValue,
        ),
        shape: ShapeBorder.lerp(
          activeShapes.elementAtOrNull(index) ?? activeShape,
          shapes.elementAtOrNull(index) ?? shape,
          lerpValue,
        )!,
      ),
    );
    return onTap == null ? dot : _wrapInkwell(dot, index);
  }

  @override
  Widget build(BuildContext context) {
    final dotsList = List<Widget>.generate(
      dotsCount,
      (i) => _buildDot(context, i),
    );
    final dots = reversed ? dotsList.reversed.toList() : dotsList;

    return axis == Axis.vertical
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: dots,
          );
  }
}
