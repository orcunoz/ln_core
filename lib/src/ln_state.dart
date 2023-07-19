import 'package:flutter/material.dart';

abstract class LnState<T extends StatefulWidget> extends State<T> {
  int _generation = 0;
  int get generation => _generation;

  void rebuild() {
    if (!mounted) return;
    setState(() {
      ++_generation;
    });
  }
}
