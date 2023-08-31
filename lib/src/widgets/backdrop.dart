import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class _BackdropScope extends InheritedWidget {
  final BackdropState state;

  const _BackdropScope({required this.state, required super.child});

  @override
  bool updateShouldNotify(_BackdropScope oldWidget) => oldWidget.state != state;
}

class Backdrop extends StatefulWidget {
  final Duration animationDuration;
  final Widget backLayer;
  final Widget frontLayer;
  final BorderRadius? frontLayerBorderRadius;
  final double frontLayerElevation;
  final bool stickyFrontLayer;
  final bool isOpen;
  final Curve animationCurve;
  final Curve? reverseAnimationCurve;
  final Color? backLayerBackgroundColor;
  final Color? frontLayerBackgroundColor;
  final double frontLayerActiveFactor;
  final Color frontLayerScrim;
  final Color backLayerScrim;
  final VoidCallback? whenOpen;
  final VoidCallback? whenClosed;

  Backdrop({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.backLayer,
    required this.frontLayer,
    this.frontLayerBorderRadius = const BorderRadius.vertical(
      top: Radius.circular(16),
    ),
    this.frontLayerElevation = 1,
    this.stickyFrontLayer = false,
    this.isOpen = false,
    this.animationCurve = Curves.ease,
    this.reverseAnimationCurve,
    this.frontLayerBackgroundColor,
    double frontLayerActiveFactor = 1,
    this.backLayerBackgroundColor,
    this.frontLayerScrim = Colors.transparent,
    this.backLayerScrim = Colors.black54,
    this.whenOpen,
    this.whenClosed,
  }) : frontLayerActiveFactor = frontLayerActiveFactor.clamp(0, 1).toDouble();

  @override
  BackdropState createState() => BackdropState();

  static BackdropState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BackdropScope>()!.state;
}

class BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ColorTween _backLayerScrimColorTween;

  double? _backPanelHeight;

  AnimationController get animationController => _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: widget.isOpen ? 1 : 0,
    );

    _backLayerScrimColorTween = _buildBackLayerScrimColorTween();

    _animationController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant Backdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backLayerScrim != widget.backLayerScrim) {
      _backLayerScrimColorTween = _buildBackLayerScrimColorTween();
    }

    if (oldWidget.isOpen != widget.isOpen) {
      widget.isOpen ? open() : close();
    }
  }

  bool get isOpen =>
      animationController.status == AnimationStatus.completed ||
      animationController.status == AnimationStatus.forward;

  bool get isClosed =>
      animationController.status == AnimationStatus.dismissed ||
      animationController.status == AnimationStatus.reverse;

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
      animationController.animateBack(-1);
      widget.whenClosed?.call();
    }
  }

  void open() {
    if (isClosed) {
      animationController.animateTo(1);
      widget.whenOpen?.call();
    }
  }

  Animation<RelativeRect> _getPanelAnimation(
      BuildContext context, BoxConstraints constraints) {
    double backPanelHeight, frontPanelHeight;
    final availableHeight = constraints.biggest.height;
    if (widget.stickyFrontLayer && (_backPanelHeight ?? 0) < availableHeight) {
      // height is adapted to the height of the back panel
      backPanelHeight = _backPanelHeight ?? 0;
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
    ).animate(CurvedAnimation(
        parent: animationController,
        curve: widget.animationCurve,
        reverseCurve:
            widget.reverseAnimationCurve ?? widget.animationCurve.flipped));
  }

  Widget _buildInactiveLayer(BuildContext context) {
    return Offstage(
      offstage: animationController.status == AnimationStatus.completed,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(animationController),
        child: GestureDetector(
          onTap: toggle,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: widget.frontLayerScrim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackPanel() {
    return Stack(
      children: [
        FocusScope(
          canRequestFocus: isClosed,
          child: Material(
            color: widget.backLayerBackgroundColor ??
                Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Measurable(
                    afterLayout: (size) =>
                        setState(() => _backPanelHeight = size.height),
                    child: widget.backLayer,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_hasBackLayerScrim) _buildBackLayerScrim(),
      ],
    );
  }

  Widget _buildFrontPanel(BuildContext context) {
    return Material(
      color: widget.frontLayerBackgroundColor,
      elevation: widget.frontLayerElevation,
      borderRadius: widget.frontLayerBorderRadius,
      child: Stack(
        children: <Widget>[
          widget.frontLayer,
          _buildInactiveLayer(context),
        ],
      ),
    );
  }

  Future<bool> _willPopCallback(BuildContext context) async {
    if (!isClosed) {
      close();
      return false;
    }
    return true;
  }

  ColorTween _buildBackLayerScrimColorTween() => ColorTween(
        begin: Colors.transparent,
        end: widget.backLayerScrim,
      );

  Widget _buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopCallback(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              _buildBackPanel(),
              PositionedTransition(
                rect: _getPanelAnimation(context, constraints),
                child: _buildFrontPanel(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Container _buildBackLayerScrim() => Container(
      color: _backLayerScrimColorTween.evaluate(animationController),
      height: _backPanelHeight);

  bool get _hasBackLayerScrim => isOpen && widget.frontLayerActiveFactor < 1;

  @override
  Widget build(BuildContext context) {
    return _BackdropScope(
      state: this,
      child: Builder(
        builder: (context) => _buildBody(context),
      ),
    );
  }
}
