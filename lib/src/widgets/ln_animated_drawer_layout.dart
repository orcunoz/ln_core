import 'package:flutter/foundation.dart';
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
    this.hideAnimationDuration = const Duration(milliseconds: 500),
    this.hideAnimationCurve = Curves.easeInOut,
    this.shrinkAnimationDuration = const Duration(milliseconds: 1000),
    this.shrinkAnimationCurve = Curves.easeInOut,
    this.controller,
    required this.drawer,
    required this.child,
  });

  final double expandedDrawerWidth;
  final double shrinkedDrawerWidth;
  final double scaleEffectFactor;
  final bool rtlOpening;
  final bool disabledGestures;

  final Duration hideAnimationDuration;
  final Curve? hideAnimationCurve;
  final Duration shrinkAnimationDuration;
  final Curve? shrinkAnimationCurve;

  final LnAnimatedDrawerController? controller;
  final Widget drawer;
  final Widget child;

  @override
  State<LnAnimatedDrawerLayout> createState() => _LnAnimatedDrawerLayoutState();
}

class _LnAnimatedDrawerLayoutState extends LnState<LnAnimatedDrawerLayout>
    with TickerProviderStateMixin {
  LnAnimatedDrawerController? _internalDrawerController;

  LnAnimatedDrawerController get _drawerController {
    return widget.controller ?? _internalDrawerController!;
  }

  late final _hideAnimationController = AnimationController(
    vsync: this,
    value: _drawerController.value.visible ? 1 : 0,
  );
  late final _shrinkAnimationController = AnimationController(
    vsync: this,
    value: _drawerController.value.shrinked ? 0 : 1,
  );

  Animation<double>? _toggleAnimation;
  Animation<double>? _shrinkAnimation;
  Animation<double>? _childScaleAnimation;

  _AnimationsLevel? _animationsLevel;
  _AnimationsLevel get animationsLevel {
    assert(_animationsLevel != null);
    return _animationsLevel!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var newAnimationsLevel = _AnimationsLevel.from(mediaQuery.layoutLevel);
    if (_animationsLevel != newAnimationsLevel) {
      _animationsLevel = newAnimationsLevel;
      _drawerController._resetStateFor(animationsLevel);

      switch (animationsLevel) {
        case _AnimationsLevel.compact:
          if (_drawerController.value.visible) {
            void statusListener(status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                _toggleAnimation!.removeStatusListener(statusListener);
                _drawerController.expand();
              }
            }

            _toggleAnimation!.addStatusListener(statusListener);
          }

          _refreshChildScaleAnimation();
          break;
        case _AnimationsLevel.mediumExpanded:
          if (_childScaleAnimation == null ||
              _drawerController.value.shrinked) {
            _refreshChildScaleAnimation();
          } else {
            void statusListener(status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                _shrinkAnimation!.removeStatusListener(statusListener);
                _refreshChildScaleAnimation();
                rebuild();
              }
            }

            _shrinkAnimation!.addStatusListener(statusListener);
          }
          break;
        case _AnimationsLevel.expandedPlus:
          _refreshChildScaleAnimation();
          break;
      }
    }
  }

  void _refreshChildScaleAnimation() {
    assert(_animationsLevel != null);
    Animation<double>? parent = _animationsLevel == _AnimationsLevel.compact
        ? _toggleAnimation
        : _shrinkAnimation;

    assert(parent != null);
    _childScaleAnimation = switch (_animationsLevel!) {
      < _AnimationsLevel.expandedPlus => Tween<double>(
          begin: 1.0,
          end: widget.scaleEffectFactor,
        ).animate(parent!),
      _ => AlwaysStoppedAnimation(1.0),
    };
  }

  @override
  void didUpdateWidget(covariant LnAnimatedDrawerLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalDrawerController)!
          .removeListener(_handleControllerChanged);

      if (widget.controller == null) {
        _internalDrawerController = LnAnimatedDrawerController()
          ..value = LnDrawerLayoutState(
            shrinked: oldWidget.controller!.value.shrinked,
            visible: oldWidget.controller!.value.visible,
          );
      } else {
        _internalDrawerController!.dispose();
        _internalDrawerController = null;
      }

      (widget.controller ?? _internalDrawerController)!
          .addListener(_handleControllerChanged);

      _handleControllerChanged();
    }

    if (widget.scaleEffectFactor != oldWidget.scaleEffectFactor) {
      _refreshChildScaleAnimation();
    }

    if (widget.expandedDrawerWidth != oldWidget.expandedDrawerWidth ||
        widget.shrinkedDrawerWidth != oldWidget.shrinkedDrawerWidth ||
        widget.rtlOpening != oldWidget.rtlOpening) {}

    if (widget.shrinkAnimationCurve != oldWidget.shrinkAnimationCurve ||
        widget.hideAnimationCurve != oldWidget.hideAnimationCurve) {
      _createAnimations();
    }

    if (widget.shrinkAnimationDuration != oldWidget.shrinkAnimationDuration ||
        widget.hideAnimationDuration != oldWidget.hideAnimationDuration) {
      _updateAnimationDurations();
    }
  }

  @override
  void initState() {
    super.initState();

    _updateAnimationDurations();
    _createAnimations();

    if (widget.controller == null) {
      _internalDrawerController = LnAnimatedDrawerController();
    }

    _drawerController.addListener(_handleControllerChanged);
  }

  void _updateAnimationDurations() {
    _shrinkAnimationController
      ..duration = widget.shrinkAnimationDuration
      ..reverseDuration = widget.shrinkAnimationDuration;
    _hideAnimationController
      ..duration = widget.hideAnimationDuration
      ..reverseDuration = widget.hideAnimationDuration;
  }

  void _createAnimations() {
    _toggleAnimation = _createAnimation(
      _hideAnimationController,
      widget.hideAnimationCurve,
    );
    _shrinkAnimation = _createAnimation(
      _shrinkAnimationController,
      widget.shrinkAnimationCurve,
    )..addListener(() {
        final shrinkTransition = _shrinkAnimation?.value;
        if (shrinkTransition != null) {
          _drawerController._shrinkNotifier.value = shrinkTransition;
        }
      });
  }

  Widget _buildChildOverlay(BuildContext context) {
    onTap() => switch (animationsLevel) {
          _AnimationsLevel.mediumExpanded => _drawerController.shrink(),
          _AnimationsLevel.compact => _drawerController.hide(),
          _AnimationsLevel.expandedPlus => ()
        };

    return ValueListenableBuilder<LnDrawerLayoutState>(
      valueListenable: _drawerController,
      builder: (context, value, overlay) {
        bool overlayEnabled = switch (animationsLevel) {
          _AnimationsLevel.compact => value.visible,
          _AnimationsLevel.mediumExpanded => !value.shrinked,
          _AnimationsLevel.expandedPlus => false,
        };
        return Offstage(
          offstage: !overlayEnabled,
          child: overlay,
        );
      },
      child: switch (widget.scaleEffectFactor) {
        1 => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (details) => onTap(),
          ),
        _ => Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: theme.surfaces.borderRadius,
              onTap: onTap,
            ),
          ),
      },
    );
  }

  Widget _buildChild(BuildContext context, TextDirection direction) {
    Widget child = Stack(
      clipBehavior: Clip.none,
      children: [
        RepaintBoundary(child: widget.child),
        _buildChildOverlay(context),
      ],
    );

    child = ScaleTransition(
      scale: _childScaleAnimation!,
      child: child,
    );

    child = AnimatedBuilder(
      animation: _toggleAnimation!,
      builder: (context, child) {
        final shrinkedStart =
            widget.shrinkedDrawerWidth * (_toggleAnimation!.value);
        final expandedStart =
            widget.expandedDrawerWidth * (_toggleAnimation!.value);
        return PositionedTransition(
          rect: RelativeRectTween(
            begin: RelativeRect.fromDirectional(
              textDirection: direction,
              top: 0,
              bottom: 0,
              start: shrinkedStart,
              end: switch (animationsLevel) {
                _AnimationsLevel.compact => -shrinkedStart,
                _AnimationsLevel.mediumExpanded => 0,
                _AnimationsLevel.expandedPlus => 0,
              },
            ),
            end: RelativeRect.fromDirectional(
              textDirection: direction,
              top: 0,
              bottom: 0,
              start: expandedStart,
              end: switch (animationsLevel) {
                _AnimationsLevel.compact => -expandedStart,
                _AnimationsLevel.mediumExpanded =>
                  shrinkedStart - expandedStart,
                _AnimationsLevel.expandedPlus => 0,
              },
            ),
          ).animate(_shrinkAnimation!),
          child: child!,
        );
      },
      child: child,
    );

    return child;
  }

  Widget _buildDrawer(BuildContext context, TextDirection direction) {
    Widget drawer = widget.drawer;

    drawer = ScaleTransition(
      scale: Tween<double>(
        begin: 1.0 / widget.scaleEffectFactor,
        end: 1.0,
      ).animate(_toggleAnimation!),
      alignment:
          widget.rtlOpening ? Alignment.centerLeft : Alignment.centerRight,
      child: drawer,
    );

    drawer = AnimatedBuilder(
      animation: _toggleAnimation!,
      builder: (context, child) {
        Rect rectFor(double transition, double maxSlide) {
          final left = switch (direction) {
            TextDirection.ltr => maxSlide * (transition - 1),
            TextDirection.rtl => mediaQuery.size.width - maxSlide * transition,
          };
          return Rect.fromLTWH(left, 0, maxSlide, mediaQuery.size.height);
        }

        return RelativePositionedTransition(
          rect: RectTween(
            begin: rectFor(_toggleAnimation!.value, widget.shrinkedDrawerWidth),
            end: rectFor(_toggleAnimation!.value, widget.expandedDrawerWidth),
          ).animate(_shrinkAnimation!),
          size: mediaQuery.size,
          child: child!,
        );
      },
      child: drawer,
    );

    return drawer;
  }

  @override
  Widget build(BuildContext context) {
    final direction = widget.rtlOpening ? TextDirection.rtl : TextDirection.ltr;
    _createAnimations();

    return GestureDetector(
      onHorizontalDragStart: widget.disabledGestures ? null : _handleDragStart,
      onHorizontalDragUpdate:
          widget.disabledGestures ? null : _handleDragUpdate,
      onHorizontalDragEnd: widget.disabledGestures ? null : _handleDragEnd,
      onHorizontalDragCancel:
          widget.disabledGestures ? null : _handleDragCancel,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildDrawer(context, direction),
          _buildChild(context, direction),
        ],
      ),
    );
  }

  Animation<double> _createAnimation(Animation<double> parent, Curve? curve) {
    return curve == null
        ? parent
        : CurvedAnimation(
            curve: curve,
            reverseCurve: curve,
            parent: parent,
          );
  }

  void _handleControllerChanged() {
    if (_drawerController.value.visible) {
      DeviceUtils.hideKeyboard(context);
    }

    // value: 0 -> shrinked   1 -> expanded
    _drawerController.value.shrinked
        ? _shrinkAnimationController.reverse()
        : _shrinkAnimationController.forward();

    // value: 0 -> hidden   1 -> visible
    _drawerController.value.visible
        ? _hideAnimationController.forward()
        : _hideAnimationController.reverse();
  }

  //bool _captured = false;
  _CapturedDragStart? _captured;

  void _handleDragStart(DragStartDetails details) {
    if (_drawerController.canHide) {
      _captured = _CapturedDragStart(
          position: details.globalPosition,
          controller: _hideAnimationController,
          slidableLength: _drawerController.value.shrinked
              ? widget.shrinkedDrawerWidth
              : widget.expandedDrawerWidth,
          completer: () => _hideAnimationController.value >= 0.5
              ? (_drawerController.value.visible
                  ? _hideAnimationController.forward()
                  : _drawerController.show())
              : (!_drawerController.value.visible
                  ? _hideAnimationController.reverse()
                  : _drawerController.hide()));
    } else {
      _captured = _CapturedDragStart(
          position: details.globalPosition,
          controller: _shrinkAnimationController,
          slidableLength:
              widget.expandedDrawerWidth - widget.shrinkedDrawerWidth,
          completer: () => _shrinkAnimationController.value >= 0.5
              ? (_drawerController.value.shrinked
                  ? _shrinkAnimationController.forward()
                  : _drawerController.expand())
              : (!_drawerController.value.shrinked
                  ? _shrinkAnimationController.reverse()
                  : _drawerController.shrink()));
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
    _drawerController.removeListener(_handleControllerChanged);
    _internalDrawerController?.dispose();
    _hideAnimationController.dispose();
    _shrinkAnimationController.dispose();

    super.dispose();
  }
}

class _CapturedDragStart {
  _CapturedDragStart({
    required this.position,
    required this.controller,
    required this.slidableLength,
    required this.completer,
  }) : value = controller.value;

  final AnimationController controller;
  final double value;
  final Offset position;
  final double slidableLength;
  final Function completer;

  void handleDragPositionUpdate(Offset newPosition, bool rtlOpening) {
    final diff = (newPosition - position).dx;
    final slideDirectionSign = (rtlOpening ? -1 : 1);
    controller.value = value + (diff / slidableLength) * slideDirectionSign;
  }
}

class LnAnimatedDrawerController extends ValueNotifier<LnDrawerLayoutState> {
  /// Creates controller with initial drawer state. (Hidden by default)
  LnAnimatedDrawerController()
      : super(const LnDrawerLayoutState(shrinked: false, visible: true));

  bool _canHide = true;

  bool get canHide => _canHide;
  set canHide(bool value) {
    if (_canHide != value) {
      _canHide = value;
      if (!_canHide && !this.value.visible) {
        show();
      } else {
        notifyListeners();
      }
    }
  }

  late final _shrinkNotifier = ValueNotifier<double>(value.shrinked ? 0 : 1);
  ValueListenable<double> get shrinkListenable => _shrinkNotifier;

  void _resetStateFor(_AnimationsLevel level) {
    switch (level) {
      case _AnimationsLevel.compact:
        canHide = true;
        hide();
        break;
      case _AnimationsLevel.mediumExpanded:
        shrink();
        show();
        canHide = false;
        break;
      case _AnimationsLevel.expandedPlus:
        expand();
        show();
        canHide = false;
        break;
    }
  }

  /// Shows drawer.
  void show() {
    value = value.copyWith(visible: true);
  }

  /// Hides drawer.
  void hide() {
    assert(canHide);
    value = value.copyWith(visible: false);
  }

  /// Toggles drawer.
  void toggleDrawer() {
    if (value.visible) {
      hide();
    } else {
      show();
    }
  }

  void expand() {
    value = value.copyWith(shrinked: false);
  }

  void shrink() {
    value = value.copyWith(shrinked: true);
  }

  void toggleShrinking() {
    if (value.shrinked) {
      expand();
    } else {
      shrink();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _shrinkNotifier.dispose();
  }
}

class LnDrawerLayoutState {
  const LnDrawerLayoutState({
    required this.shrinked,
    required this.visible,
  });

  final bool visible;
  final bool shrinked;

  LnDrawerLayoutState copyWith({
    bool? visible,
    bool? shrinked,
  }) {
    return LnDrawerLayoutState(
      visible: visible ?? this.visible,
      shrinked: shrinked ?? this.shrinked,
    );
  }
}
