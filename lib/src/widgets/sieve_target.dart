part of 'sieve_area.dart';

class SieveTarget extends StatefulWidget {
  final Widget child;
  const SieveTarget({super.key, required this.child});

  @override
  State<SieveTarget> createState() => _SieveTargetState();
}

class _SieveTargetState extends State<SieveTarget> {
  final RenderTransform _renderTransform =
      RenderTransform(transform: Matrix4.identity());

  RenderTransform get renderTransform => _renderTransform;
  Matrix4 getTransformTo(RenderObject? ancestor) =>
      _renderTransform.getTransformTo(ancestor);

  Size get size => _renderTransform.size;
  bool _visible = true;

  set visible(bool value) {
    if (_visible != value) {
      setState(() {
        _visible = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _SieveAreaScope.of(context).register(this);
    });
  }

  @override
  void dispose() {
    _SieveAreaScope.of(context).unregister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SieveTargetRenderObject(
      renderTransform: _renderTransform,
      child: Visibility.maintain(
        visible: _visible,
        child: widget.child,
      ),
    );
  }
}

class SieveTargetRenderObject extends SingleChildRenderObjectWidget {
  final RenderTransform renderTransform;

  const SieveTargetRenderObject({
    super.key,
    required this.renderTransform,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return renderTransform;
  }
}
