import 'package:flutter/material.dart';

abstract class LnState<T extends StatefulWidget> extends State<T> {
  int _generation = 0;
  int get generation => _generation;

  void rebuild({bool withWidgetsBindingCallback = false}) {
    if (!mounted) return;
    rebuildFunc() => setState(() {
          ++_generation;
        });

    withWidgetsBindingCallback
        ? WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) => rebuildFunc(),
          )
        : rebuildFunc();
  }
}

extension FunctionExtensions on Function {
  nullIf(bool expression) => expression ? null : this;
  nullIfNot(bool expression) => !expression ? null : this;
}
