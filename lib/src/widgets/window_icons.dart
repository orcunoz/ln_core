import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const double kMinimumWindowWidth = 350;
const double kMinimumWindowHeight = 500;

const double kInitialWindowWidth = 1240;
const double kInitialWindowHeight = 800;

Offset? _lastSavedPosition;
Size? _lastSavedSize;

class WindowIcons extends StatelessWidget {
  final Color? color;
  final double? iconSize;
  const WindowIcons({super.key, this.color, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: windowManager.minimize,
          icon: Icon(
            Icons.minimize,
            color: color,
          ),
        ),
        IconButton(
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              if (_lastSavedPosition != null) {
                windowManager.setPosition(_lastSavedPosition!);
              } else {
                windowManager.center();
              }

              if (_lastSavedSize != null) {
                windowManager.setSize(_lastSavedSize!);
              } else {
                windowManager
                    .setSize(Size(kMinimumWindowWidth, kMinimumWindowHeight));
              }
              windowManager.setFullScreen(false);
            } else {
              _lastSavedSize = await windowManager.getSize();
              _lastSavedPosition = await windowManager.getPosition();
              windowManager.setFullScreen(true);
            }
          },
          icon: Icon(
            Icons.fullscreen_rounded,
            color: color,
          ),
        ),
        IconButton(
          onPressed: windowManager.close,
          icon: Icon(
            Icons.close_rounded,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
    return child;
  }
}
