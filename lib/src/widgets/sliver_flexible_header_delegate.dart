import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef FlexibleBuilder = Widget Function(
  BuildContext context,
  double progress,
);

class FlexibleHeaderDelegate extends SliverPersistentHeaderDelegate {
  FlexibleHeaderDelegate({
    this.collapsedHeight = kToolbarHeight,
    this.expandedHeight = kToolbarHeight * 3,
    this.children,
    this.actions,
    this.title,
    this.backgroundColor,
    this.background,
    this.collapsedElevation = 8,
    this.expandedElevation = 0,
    this.leading,
    this.builder,
    this.statusBarHeight = 0,
  });

  final List<Widget>? actions;
  final Widget? leading;
  final Widget? title;

  final double expandedHeight;
  final double collapsedHeight;
  final List<Widget>? children;
  final Color? backgroundColor;
  final Widget? background;
  final double expandedElevation;
  final double collapsedElevation;
  final FlexibleBuilder? builder;

  final double statusBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final offset = math.min(shrinkOffset, maxExtent - minExtent);
    final progress = offset / (maxExtent - minExtent);

    final visibleMainHeight = math.max(maxExtent - shrinkOffset, minExtent);

    return Material(
      elevation: progress < 1 ? expandedElevation : collapsedElevation,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (background != null) background!.transform(progress),
          Container(
            height: visibleMainHeight,
            padding: EdgeInsets.only(top: statusBarHeight),
            color: backgroundColor ??
                Theme.of(context).appBarTheme.backgroundColor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (builder != null) builder!(context, progress),
                if (children != null)
                  ...children!.map((item) => item.transform(progress)),
              ],
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            actions: actions,
            leading: leading,
            title: title,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + statusBarHeight;

  @override
  double get minExtent => collapsedHeight + statusBarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

enum HeaderItemOptions {
  scale,
  hide,
}

class FlexibleHeaderItem extends Widget {
  const FlexibleHeaderItem({
    super.key,
    this.child,
    this.alignment,
    this.expandedAlignment,
    this.collapsedAlignment,
    this.padding,
    this.expandedPadding,
    this.collapsedPadding,
    this.margin,
    this.expandedMargin,
    this.collapsedMargin,
    this.options = const [],
  })  : assert(alignment == null ||
            (expandedAlignment == null && collapsedAlignment == null)),
        assert(padding == null ||
            (expandedPadding == null && collapsedPadding == null)),
        assert(margin == null ||
            (expandedMargin == null && collapsedMargin == null));

  final Alignment? alignment;
  final Alignment? expandedAlignment;
  final Alignment? collapsedAlignment;

  final EdgeInsets? padding;
  final EdgeInsets? expandedPadding;
  final EdgeInsets? collapsedPadding;

  final EdgeInsets? margin;
  final EdgeInsets? expandedMargin;
  final EdgeInsets? collapsedMargin;

  final List<HeaderItemOptions> options;

  final Widget? child;

  @override
  Element createElement() =>
      throw Exception('Unable to wrap $this with other widgets');
}

class FlexibleTextItem extends FlexibleHeaderItem {
  const FlexibleTextItem({
    super.key,
    required this.text,
    this.collapsedStyle,
    this.expandedStyle,
    this.maxLines,
    this.textScaler,
    this.overflow,
    this.softWrap,
    this.locale,
    this.textDirection,
    this.textAlign,
    super.alignment,
    super.expandedAlignment,
    super.collapsedAlignment,
    super.padding,
    super.expandedPadding,
    super.collapsedPadding,
    super.margin,
    super.expandedMargin,
    super.collapsedMargin,
    super.options = const [],
  });

  final String text;

  final TextStyle? collapsedStyle;
  final TextStyle? expandedStyle;

  final int? maxLines;
  final TextScaler? textScaler;
  final TextOverflow? overflow;
  final bool? softWrap;
  final Locale? locale;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
}

class FlexibleTextItemWidget extends StatelessWidget {
  const FlexibleTextItemWidget(
    this._item,
    this._progress, {
    super.key,
  });

  final FlexibleTextItem? _item;
  final double _progress;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: _item!.paddingValue(_progress),
      margin: _item!.marginValue(_progress),
      alignment: _item!.alignmentValue(_progress),
      child: Text(
        _item!.text,
        style: TextStyle.lerp(
          _item!.expandedStyle,
          _item!.collapsedStyle,
          _progress,
        ),
        maxLines: _item!.maxLines,
        textScaler: _item!.textScaler,
        overflow: _item!.overflow,
        softWrap: _item!.softWrap,
        locale: _item!.locale,
        textDirection: _item!.textDirection,
        textAlign: _item!.textAlign,
      ),
    );
  }
}

class HeaderItemWidget extends StatelessWidget {
  const HeaderItemWidget(
    this._item,
    this._progress, {
    super.key,
  });

  final FlexibleHeaderItem? _item;
  final double _progress;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      padding: _item!.paddingValue(_progress),
      margin: _item!.marginValue(_progress),
      alignment: _item!.alignmentValue(_progress),
      child: _item!.child != null ? _wrapWithOpacity() : const SizedBox(),
    );
  }

  Widget? _wrapWithOpacity() {
    return _item!.options.contains(HeaderItemOptions.hide)
        ? AnimatedOpacity(
            opacity: 1 - _progress,
            duration: const Duration(milliseconds: 150),
            child: _wrapWithScale())
        : _wrapWithScale();
  }

  Widget? _wrapWithScale() {
    return _item!.options.contains(HeaderItemOptions.scale)
        ? Transform.scale(
            scale: Tween<double>(begin: 1, end: 0).transform(_progress),
            child: _item!.child,
          )
        : _item!.child;
  }
}

abstract class HeaderBackground extends Widget {
  const HeaderBackground({super.key});

  @override
  Element createElement() =>
      throw Exception('Unable to wrap $this with other widgets');
}

class MutableBackground extends HeaderBackground {
  const MutableBackground({
    this.expandedWidget,
    this.expandedColor,
    this.collapsedWidget,
    this.collapsedColor,
    this.animationDuration = const Duration(milliseconds: 150),
    super.key,
  })  : assert(expandedColor == null || expandedWidget == null),
        assert(collapsedColor == null || collapsedWidget == null);

  final Widget? expandedWidget;
  final Widget? collapsedWidget;
  final Color? expandedColor;
  final Color? collapsedColor;
  final Duration animationDuration;
}

class GradientBackground extends HeaderBackground {
  const GradientBackground({
    required this.gradient,
    this.modifyGradient = true,
    super.key,
  });

  final Gradient gradient;
  final bool modifyGradient;
}

class MutableBackgroundWidget extends StatelessWidget {
  const MutableBackgroundWidget(
    this._progress,
    this._mutableBackground, {
    super.key,
  });

  final double _progress;
  final MutableBackground? _mutableBackground;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedOpacity(
          duration: _mutableBackground!.animationDuration,
          opacity: _progress,
          child: _buildWidget(
            _mutableBackground!.collapsedWidget,
            _mutableBackground!.collapsedColor,
          ),
        ),
        AnimatedOpacity(
          duration: _mutableBackground!.animationDuration,
          opacity: 1 - _progress,
          child: _buildWidget(
            _mutableBackground!.expandedWidget,
            _mutableBackground!.expandedColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWidget(Widget? widget, Color? color) {
    return widget ??
        (color == null ? const SizedBox() : Container(color: color));
  }
}

class GradientBackgroundWidget extends StatelessWidget {
  const GradientBackgroundWidget(
    this._progress,
    this._gradientBackground, {
    super.key,
  });

  final double _progress;
  final GradientBackground? _gradientBackground;

  @override
  Widget build(BuildContext context) {
    return _gradientBackground!.modifyGradient
        ? ShaderMask(
            blendMode: BlendMode.src,
            shaderCallback: (bounds) {
              return _gradientBackground!.gradient.createShader(
                Rect.fromLTWH(
                  0,
                  0,
                  Tween<double>(begin: bounds.width, end: 0)
                      .transform(_progress),
                  Tween<double>(begin: bounds.height, end: 0)
                      .transform(_progress),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: _gradientBackground!.gradient,
            ),
          );
  }
}

extension XWidget on Widget {
  Widget transform(double progress) {
    if (this is FlexibleTextItem) {
      return FlexibleTextItemWidget(this as FlexibleTextItem?, progress);
    } else if (this is FlexibleHeaderItem) {
      return HeaderItemWidget(this as FlexibleHeaderItem?, progress);
    } else if (this is MutableBackground) {
      return MutableBackgroundWidget(progress, this as MutableBackground?);
    } else if (this is GradientBackground) {
      return GradientBackgroundWidget(progress, this as GradientBackground?);
    }

    return this;
  }
}

extension XHeaderItem on FlexibleHeaderItem {
  EdgeInsets? paddingValue(double progress) => EdgeInsets.lerp(
        expandedPadding ?? padding,
        collapsedPadding ?? padding,
        progress,
      );

  EdgeInsets? marginValue(double progress) => EdgeInsets.lerp(
        expandedMargin ?? margin,
        collapsedMargin ?? margin,
        progress,
      );

  Alignment? alignmentValue(double progress) => Alignment.lerp(
        expandedAlignment ?? alignment,
        collapsedAlignment ?? alignment,
        progress,
      );
}
