import 'package:flutter/material.dart' hide BottomSheet;
import 'package:flutter/scheduler.dart';
import 'package:ln_core/ln_core.dart';

class _BackdropScope extends InheritedWidget {
  final BackdropState state;

  const _BackdropScope({required this.state, required super.child});

  @override
  bool updateShouldNotify(_BackdropScope oldWidget) => oldWidget.state != state;
}

class Backdrop extends StatefulWidget {
  Backdrop({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.backLayer,
    required this.frontLayer,
    this.frontLayerBackgroundColor,
    this.frontLayerBorderRadius = const BorderRadius.vertical(
      top: Radius.circular(12),
    ),
    double frontLayerActiveFactor = 1,
    this.stickyFrontLayer = false,
    this.isOpen = false,
    this.animationCurve = Curves.ease,
    this.reverseAnimationCurve,
    Color backLayerScrim = Colors.black54,
    this.whenOpen,
    this.whenClosed,
  })  : frontLayerActiveFactor = frontLayerActiveFactor.clamp(0, 1).toDouble(),
        backLayerScrimColorTween = ColorTween(
          begin: Colors.transparent,
          end: backLayerScrim,
        );

  final Duration animationDuration;
  final Widget backLayer;
  final ColorTween backLayerScrimColorTween;
  final Widget frontLayer;
  final Color? frontLayerBackgroundColor;
  final BorderRadius? frontLayerBorderRadius;
  final double frontLayerActiveFactor;
  final bool stickyFrontLayer;
  final bool isOpen;
  final Curve animationCurve;
  final Curve? reverseAnimationCurve;
  final VoidCallback? whenOpen;
  final VoidCallback? whenClosed;

  @override
  BackdropState createState() => BackdropState();

  static BackdropState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BackdropScope>()!.state;
}

class BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
    value: widget.isOpen ? 1 : 0,
  );
  final _backPanelHeight = ValueNotifier<double?>(null);

  @override
  void didUpdateWidget(covariant Backdrop oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isOpen != widget.isOpen) {
      widget.isOpen ? open() : close();
    }
  }

  bool get isOpen =>
      _animationController.status == AnimationStatus.completed ||
      _animationController.status == AnimationStatus.forward;

  bool get isClosed =>
      _animationController.status == AnimationStatus.dismissed ||
      _animationController.status == AnimationStatus.reverse;

  void toggle() {
    FocusScope.of(context).unfocus();
    if (isOpen) {
      close();
    } else {
      open();
    }
  }

  void close() {
    if (isOpen) {
      _animationController.animateBack(-1);
      widget.whenClosed?.call();
    }
  }

  void open() {
    if (isClosed) {
      _animationController.animateTo(1);
      widget.whenOpen?.call();
    }
  }

  /*Animation<RelativeRect> _getPanelAnimation(
      BuildContext context, BoxConstraints constraints) {
    double backPanelHeight, frontPanelHeight;
    final availableHeight = constraints.biggest.height;
    if (widget.stickyFrontLayer &&
        (_backPanelHeight.value ?? 0) < availableHeight) {
      // height is adapted to the height of the back panel
      backPanelHeight = _backPanelHeight.value ?? 0;
      frontPanelHeight = -backPanelHeight;
    } else {
      // height is set to fixed value defined in widget.headerHeight
      backPanelHeight = availableHeight;
      frontPanelHeight = -backPanelHeight;
    }
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, backPanelHeight, 0, frontPanelHeight),
      end: RelativeRect.fromLTRB(
          0, availableHeight * (1 - widget.frontLayerActiveFactor), 0, 0),
    ).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: widget.animationCurve,
          reverseCurve:
              widget.reverseAnimationCurve ?? widget.animationCurve.flipped),
    );
  }*/

  Widget _buildBackPanel() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FocusScope(
          canRequestFocus: isClosed,
          child: Measurable(
            onLayout: (size) => SchedulerBinding.instance.endOfFrame
                .then((value) => _backPanelHeight.value = size.height),
            child: widget.backLayer,
          ),
        ),
        Offstage(
          offstage: !isOpen || widget.frontLayerActiveFactor == 1,
          child: ValueListenableBuilder(
            valueListenable: _backPanelHeight,
            builder: (context, height, child) => Container(
              color: widget.backLayerScrimColorTween
                  .evaluate(_animationController),
              height: _backPanelHeight.value,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    if (!isClosed) {
      close();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return _BackdropScope(
      state: this,
      child: WillPopScope(
        onWillPop: () => _willPopCallback(context),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _buildBackPanel(),
            BottomSheet(
              open: isOpen,
              animationDuration: widget.animationDuration,
              animationCurve: widget.animationCurve,
              child: widget.frontLayer,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
