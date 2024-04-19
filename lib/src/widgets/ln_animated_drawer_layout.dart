// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ln_core/ln_core.dart';

enum _AnimationsLevel {
  compact(1),
  mediumExpanded(2),
  expandedPlus(3);

  const _AnimationsLevel(this.value);

  factory _AnimationsLevel.from(LayoutLevel level) => switch (level) {
        LayoutLevel.compact => _AnimationsLevel.compact,
        LayoutLevel.medium ||
        LayoutLevel.expanded =>
          _AnimationsLevel.mediumExpanded,
        LayoutLevel.expandedPlus => _AnimationsLevel.expandedPlus,
      };

  final int value;

  bool operator <(_AnimationsLevel operand) => value < operand.value;

  bool operator <=(_AnimationsLevel operand) => value <= operand.value;

  bool operator >(_AnimationsLevel operand) => value > operand.value;

  bool operator >=(_AnimationsLevel operand) => value >= operand.value;
}

class LnAnimatedDrawerLayout extends StatefulWidget {
  const LnAnimatedDrawerLayout({
    super.key,
    required this.expandedDrawerWidth,
    required this.shrinkedDrawerWidth,
    this.scaleEffectFactor = 0.90,
    this.rtlOpening = false,
    this.disabledGestures = false,
    this.controller,
    required this.drawer,
    required this.child,
  });

  final double expandedDrawerWidth;
  final double shrinkedDrawerWidth;
  final double scaleEffectFactor;
  final bool rtlOpening;
  final bool disabledGestures;

  final LnAnimatedDrawerController? controller;
  final Widget drawer;
  final Widget child;

  @override
  State<LnAnimatedDrawerLayout> createState() => _LnAnimatedDrawerLayoutState();
}

class _LnAnimatedDrawerLayoutState extends LnState<LnAnimatedDrawerLayout>
    with TickerProviderStateMixin {
  LnAnimatedDrawerController? _localController;
  LnAnimatedDrawerController get controller =>
      widget.controller ?? _localController!;

  _CapturedDragStart? _captured;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final level = _AnimationsLevel.from(layoutLevel);
    controller._setAnimationsLevel(level);
  }

  @override
  void didUpdateWidget(covariant LnAnimatedDrawerLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      final oldController = oldWidget.controller ?? _localController!;
      oldController.removeListener(_handleControllerChanged);

      if (widget.controller == null) {
        _localController = LnAnimatedDrawerController(
          vsync: this,
          initialLayoutLevel: layoutLevel,
        );
      } else {
        _localController!.dispose();
        _localController = null;
      }

      controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _localController = LnAnimatedDrawerController(
        vsync: this,
        initialLayoutLevel: layoutLevel,
      );
    }

    controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    if (controller.value.hidden) {
      DeviceUtils.hideKeyboard(context);
    }
  }

  Widget _buildChildOverlay(BuildContext context) {
    onTap() => switch (controller._animationsLevel) {
          _AnimationsLevel.mediumExpanded => controller.shrink(),
          _AnimationsLevel.compact => controller.hide(),
          _AnimationsLevel.expandedPlus => ()
        };

    return ValueListenableBuilder<LnDrawerLayoutState>(
      valueListenable: controller,
      builder: (context, value, overlay) {
        bool overlayEnabled = switch (controller._animationsLevel) {
          _AnimationsLevel.compact => !value.hidden,
          _AnimationsLevel.mediumExpanded => !value.shrinked,
          _AnimationsLevel.expandedPlus => false,
        };
        return Offstage(
          offstage: !overlayEnabled,
          child: overlay,
        );
      },
      child: switch (widget.scaleEffectFactor) {
        /*1 => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (details) => onTap(),
          ),*/
        _ => Material(
            type: MaterialType.transparency,
            child: InkWell(
              //borderRadius: theme.surfaces.borderRadius,
              onTap: onTap,
            ),
          ),
      },
    );
  }

  Widget _buildChild(BuildContext context, TextDirection direction) {
    final scaleAnimation = switch (controller._animationsLevel) {
      < _AnimationsLevel.expandedPlus => Tween<double>(
          begin: 1.0,
          end: widget.scaleEffectFactor,
        ).animate(controller._animationsLevel == _AnimationsLevel.compact
            ? controller.hideAnimation
            : controller.shrinkAnimation),
      _ => AlwaysStoppedAnimation(1.0),
    };

    Animation<RelativeRect> positionAnimation(double hideTransition) {
      final reverseTransition = 1 - hideTransition;
      final shrinkedStart = widget.shrinkedDrawerWidth * reverseTransition;
      final expandedStart = widget.expandedDrawerWidth * reverseTransition;

      return RelativeRectTween(
        begin: RelativeRect.fromDirectional(
          textDirection: direction,
          top: 0,
          bottom: 0,
          start: expandedStart,
          end: switch (controller._animationsLevel) {
            _AnimationsLevel.compact => -expandedStart,
            _AnimationsLevel.mediumExpanded => shrinkedStart - expandedStart,
            _AnimationsLevel.expandedPlus => 0,
          },
        ),
        end: RelativeRect.fromDirectional(
          textDirection: direction,
          top: 0,
          bottom: 0,
          start: shrinkedStart,
          end: switch (controller._animationsLevel) {
            _AnimationsLevel.compact => -shrinkedStart,
            _AnimationsLevel.mediumExpanded => 0,
            _AnimationsLevel.expandedPlus => 0,
          },
        ),
      ).animate(controller.shrinkAnimation);
    }

    return AnimatedBuilder(
      animation: controller.hideAnimation,
      builder: (context, child) {
        return PositionedTransition(
          rect: positionAnimation(controller.hideAnimation.value),
          child: child!,
        );
      },
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            RepaintBoundary(child: widget.child),
            _buildChildOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, TextDirection direction) {
    final scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0 / widget.scaleEffectFactor,
    ).animate(controller.hideAnimation);

    Animation<Rect?> positionAnimation(double hideTransition) {
      Rect rectFor(double maxSlide) {
        final reverseTransition = 1 - hideTransition;
        final left = switch (direction) {
          TextDirection.ltr => maxSlide * (reverseTransition - 1),
          TextDirection.rtl =>
            mediaQuery.size.width - maxSlide * reverseTransition,
        };
        return Rect.fromLTWH(left, 0, maxSlide, mediaQuery.size.height);
      }

      return RectTween(
        begin: rectFor(widget.expandedDrawerWidth),
        end: rectFor(widget.shrinkedDrawerWidth),
      ).animate(controller.shrinkAnimation);
    }

    return AnimatedBuilder(
      animation: controller.hideAnimation,
      builder: (context, child) {
        return RelativePositionedTransition(
          rect: positionAnimation(controller.hideAnimation.value),
          size: mediaQuery.size,
          child: child!,
        );
      },
      child: ScaleTransition(
        scale: scaleAnimation,
        alignment:
            widget.rtlOpening ? Alignment.centerLeft : Alignment.centerRight,
        child: widget.drawer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final direction = widget.rtlOpening ? TextDirection.rtl : TextDirection.ltr;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildDrawer(context, direction),
        _buildChild(context, direction),
        if (!widget.disabledGestures)
          Positioned.fill(
            top: kToolbarHeight,
            child: GestureDetector(
              onHorizontalDragStart: _handleDragStart,
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              onHorizontalDragCancel: _handleDragCancel,
            ),
          ),
      ],
    );
  }

  void _handleDragStart(DragStartDetails details) {
    if (controller.hideable) {
      _captured = _CapturedDragStart(
        position: details.globalPosition,
        slidableLength: controller.value.shrinked
            ? widget.shrinkedDrawerWidth
            : widget.expandedDrawerWidth,
        completer: controller._completeHideAnimation,
        value: controller.hideAnimation.value,
        valueChanged: (value) {
          controller._hideController.value = value;
        },
      );
    } else {
      _captured = _CapturedDragStart(
        position: details.globalPosition,
        slidableLength: widget.expandedDrawerWidth - widget.shrinkedDrawerWidth,
        completer: controller._completeShrinkAnimation,
        value: controller.shrinkAnimation.value,
        valueChanged: (value) {
          controller._shrinkController.value = value;
        },
      );
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _captured?.handleDragPositionUpdate(
        details.globalPosition, widget.rtlOpening);
  }

  void _handleDragEnd(DragEndDetails details) {
    _captured?.completer();
    _captured = null;
  }

  void _handleDragCancel() {
    _captured = null;
  }

  @override
  void dispose() {
    controller.removeListener(_handleControllerChanged);
    _localController?.dispose();

    super.dispose();
  }
}

class _CapturedDragStart {
  _CapturedDragStart({
    required this.value,
    required this.valueChanged,
    required this.position,
    required this.slidableLength,
    required this.completer,
  });

  final double value;
  final ValueChanged<double> valueChanged;
  final Offset position;
  final double slidableLength;
  final VoidCallback completer;

  void handleDragPositionUpdate(Offset newPosition, bool rtlOpening) {
    final diff = (newPosition - position).dx;
    final slideDirectionSign = (rtlOpening ? 1 : -1);
    valueChanged(value + (diff / slidableLength) * slideDirectionSign);
  }
}

class LnAnimatedDrawerController extends ValueNotifier<LnDrawerLayoutState> {
  LnAnimatedDrawerController({
    required LayoutLevel initialLayoutLevel,
    required TickerProvider vsync,
    Duration hideAnimationDuration = const Duration(milliseconds: 500),
    Curve hideAnimationCurve = Curves.easeInOut,
    Duration shrinkAnimationDuration = const Duration(milliseconds: 750),
    Curve shrinkAnimationCurve = Curves.easeInOut,
  }) : this._(
          vsync: vsync,
          animationsLevel: _AnimationsLevel.from(initialLayoutLevel),
          hideAnimationDuration: hideAnimationDuration,
          shrinkAnimationDuration: shrinkAnimationDuration,
          hideAnimationCurve: hideAnimationCurve,
          shrinkAnimationCurve: shrinkAnimationCurve,
        );

  LnAnimatedDrawerController._({
    required TickerProvider vsync,
    required _AnimationsLevel animationsLevel,
    required Duration hideAnimationDuration,
    required this.hideAnimationCurve,
    required Duration shrinkAnimationDuration,
    required this.shrinkAnimationCurve,
  })  : _animationsLevel = animationsLevel,
        _hideable = animationsLevel == _AnimationsLevel.compact,
        super(LnDrawerLayoutState._byLevel(animationsLevel)) {
    _hideController = AnimationController(
      vsync: vsync,
      value: value.hidden ? 1 : 0,
      duration: hideAnimationDuration,
    )..addStatusListener((status) {
        if (_animationValueHidden != value.hidden) {
          value = value.copyWith(hidden: _animationValueHidden);
        }
      });

    _shrinkController = AnimationController(
      vsync: vsync,
      value: value.shrinked ? 1 : 0,
      duration: shrinkAnimationDuration,
    )..addStatusListener((status) {
        if (_animationValueShrinked != value.shrinked) {
          value = value.copyWith(shrinked: _animationValueShrinked);
        }
      });
  }

  bool get _animationValueHidden => hideAnimation.value >= .5;
  bool get _animationValueShrinked => shrinkAnimation.value >= .5;

  late final AnimationController _hideController;
  late final AnimationController _shrinkController;

  Animation<double> get hideAnimation => _hideController;
  Animation<double> get shrinkAnimation => _shrinkController;

  final Curve hideAnimationCurve;
  final Curve shrinkAnimationCurve;

  bool _hideable;
  bool get hideable => _hideable;

  void _setHideable(bool value) {
    if (_hideable != value) {
      _hideable = value;
      if (!_hideable) show();
      notifyListeners();
    }
  }

  _AnimationsLevel _animationsLevel;

  void _setAnimationsLevel(_AnimationsLevel level) {
    if (_animationsLevel != level) {
      _animationsLevel = level;
      _setHideable(_animationsLevel == _AnimationsLevel.compact);

      switch (_animationsLevel) {
        case _AnimationsLevel.compact:
          expand();
          hide();
          break;
        case _AnimationsLevel.mediumExpanded:
          shrink();
          break;
        case _AnimationsLevel.expandedPlus:
          expand();
          break;
      }
    }
  }

  // hide - show
  void hide() {
    assert(hideable);
    _hideController.animateTo(1, curve: hideAnimationCurve);
  }

  void show() {
    _hideController.animateTo(0, curve: hideAnimationCurve);
  }

  void toggleDrawer() => _animationValueHidden ? show() : hide();

  void _completeHideAnimation() => _animationValueHidden ? hide() : show();

  // shrink - expand
  void shrink() {
    _shrinkController.animateTo(1, curve: shrinkAnimationCurve);
  }

  void expand() {
    _shrinkController.animateTo(0, curve: shrinkAnimationCurve);
  }

  void toggleShrinking() => _animationValueShrinked ? expand() : shrink();

  void _completeShrinkAnimation() =>
      _animationValueShrinked ? shrink() : expand();

  @override
  void dispose() {
    _hideController.dispose();
    _shrinkController.dispose();

    super.dispose();
  }
}

class LnDrawerLayoutState {
  const LnDrawerLayoutState({
    required this.shrinked,
    required this.hidden,
  });

  factory LnDrawerLayoutState._byLevel(_AnimationsLevel level) =>
      switch (level) {
        _AnimationsLevel.compact =>
          LnDrawerLayoutState(hidden: true, shrinked: false),
        _AnimationsLevel.mediumExpanded =>
          LnDrawerLayoutState(hidden: false, shrinked: true),
        _AnimationsLevel.expandedPlus =>
          LnDrawerLayoutState(hidden: false, shrinked: false),
      };

  final bool hidden;
  final bool shrinked;

  LnDrawerLayoutState copyWith({
    bool? hidden,
    bool? shrinked,
  }) {
    return LnDrawerLayoutState(
      hidden: hidden ?? this.hidden,
      shrinked: shrinked ?? this.shrinked,
    );
  }

  @override
  String toString() =>
      'LnDrawerLayoutState(hidden: $hidden, shrinked: $shrinked)';
}
