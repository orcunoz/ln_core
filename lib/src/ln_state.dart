import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ln_core/ln_core.dart';

abstract class LnContextDependentsGetters {
  ThemeData get theme;
  MediaQueryData get mediaQuery;
  FlutterView get view;
  TextDirection get textDirection;
  DividerBorders get dividerBorders;
}

final class LnContextDependents implements LnContextDependentsGetters {
  LnContextDependents(BuildContext context) : _context = context;
  LnContextDependents._() : _context = null;

  BuildContext? _context;

  @override
  ThemeData get theme => _theme ??= Theme.of(_context!);
  ThemeData? _theme;

  @override
  MediaQueryData get mediaQuery => _mediaQuery ??= MediaQuery.of(_context!);
  MediaQueryData? _mediaQuery;

  @override
  FlutterView get view => _view ??= View.of(_context!);
  FlutterView? _view;

  @override
  TextDirection get textDirection =>
      _textDirection ??= Directionality.maybeOf(_context!) ?? TextDirection.ltr;
  TextDirection? _textDirection;

  @override
  DividerBorders get dividerBorders =>
      _dividerBorders ??= DividerBorders(theme.dividerColor);
  DividerBorders? _dividerBorders;

  @mustCallSuper
  void _resetContextDependents(BuildContext context) {
    _context = context;
    _theme = null;
    _mediaQuery = null;
    _view = null;
    _textDirection = null;
    _dividerBorders = null;
  }
}

abstract mixin class LnContextDependentsMixin
    implements LnContextDependentsGetters {
  LnContextDependentsGetters get contextDependents;

  @override
  ThemeData get theme => contextDependents.theme;

  @override
  MediaQueryData get mediaQuery => contextDependents.mediaQuery;

  @override
  FlutterView get view => contextDependents.view;

  @override
  DividerBorders get dividerBorders => contextDependents.dividerBorders;

  @override
  TextDirection get textDirection => contextDependents.textDirection;
}

class LnContextDependentsWidget extends StatelessWidget
    with LnContextDependentsMixin {
  LnContextDependentsWidget({super.key});

  @override
  final LnContextDependents contextDependents = LnContextDependents._();

  static const _emptyWidget = UnusableWidget();

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    contextDependents._resetContextDependents(context);
    return _emptyWidget;
  }
}

abstract class LnContextDependentsState<W extends StatefulWidget>
    extends State<W> with LnContextDependentsMixin {
  @override
  final LnContextDependents contextDependents = LnContextDependents._();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    contextDependents._resetContextDependents(context);
  }
}

mixin AfterLayout<W extends StatefulWidget> on State<W> {
  @mustCallSuper
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) afterLayout();
    });
  }

  void afterLayout() {}
}

class LnSchedulerCallbacks {
  LnSchedulerCallbacks._();

  static FutureOr<void> endOfFrame([VoidCallback? callback]) async {
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
    }
    if (callback != null) {
      callback();
    }
  }
}

mixin LnStateSchedulerCallbacks<W extends StatefulWidget> on State<W> {
  FutureOr<void> rebuild([VoidCallback? callback]) => endOfFrame(
        () => setState(callback ?? () {}),
      );

  FutureOr<void> endOfFrame([VoidCallback? callback]) =>
      LnSchedulerCallbacks.endOfFrame(
        callback == null
            ? null
            : () => !mounted
                ? Log.w(
                    "Callback could not be called. "
                    "Because state($runtimeType) is not mounted",
                  )
                : callback(),
      );
}

abstract class LnState<W extends StatefulWidget>
    extends LnContextDependentsState<W>
    with AfterLayout<W>, LnStateSchedulerCallbacks<W> {}
