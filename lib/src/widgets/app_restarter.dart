import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class AppRestarter extends StatefulWidget {
  const AppRestarter({super.key, required this.child});

  final Widget child;

  @override
  State<AppRestarter> createState() => _AppRestarterState();

  static restart(BuildContext context) {
    context.findAncestorStateOfType<_AppRestarterState>()!.restartApp();
  }
}

class _AppRestarterState extends State<AppRestarter> {
  Key _key = UniqueKey();

  void restartApp() {
    LnSchedulerCallbacks.endOfFrame(() {
      setState(() {
        _key = UniqueKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
