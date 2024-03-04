import 'package:flutter/material.dart';

class UnusableWidget extends Widget {
  const UnusableWidget({this.invalidUsageMessage});

  final String? invalidUsageMessage;

  @override
  Element createElement() {
    throw Exception(invalidUsageMessage ?? "Invalid usage!");
  }
}
