import 'package:flutter/material.dart';

import 'package:universal_platform/universal_platform.dart';

final class UI {
  const UI._();

  static Orientation? get implicitViewOrientation {
    final Size? size =
        WidgetsBinding.instance.platformDispatcher.implicitView?.physicalSize;
    return size == null
        ? null
        : size.width > size.height
            ? Orientation.landscape
            : Orientation.portrait;
  }

  static const double formVerticalSpacing = 14.0;
  static const double formHorizontalSpacing = 8.0;

  static const EdgeInsets formMargin = EdgeInsets.all(12);
  static const EdgeInsets formPadding = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 12,
  );

  static const double drawerShrinkedWidth = 78.0;
  static const double drawerExpandedWidth = 310.0;

  static const double columnWidth = 540;
  static const double columnMaxWidth = 720;
  static const double formsMaxWidth = 640;
  static const double compactLayoutThreshold =
      columnWidth + drawerShrinkedWidth;
  static const double expandedLayoutThreshold =
      2 * columnWidth + drawerShrinkedWidth;
  static const double expandedPlusLayoutThreshold =
      2 * columnWidth + drawerExpandedWidth;
  static const double maxDialogWidth = compactLayoutThreshold - 40;

  static const EdgeInsets miniEndDockedFABPadding = EdgeInsets.only(bottom: 12);

  static final UniversalPlatformType platform = UniversalPlatform.isAndroid
      ? UniversalPlatformType.Android
      : UniversalPlatform.isIOS
          ? UniversalPlatformType.IOS
          : UniversalPlatform.isFuchsia
              ? UniversalPlatformType.Fuchsia
              : UniversalPlatform.isWindows
                  ? UniversalPlatformType.Windows
                  : UniversalPlatform.isLinux
                      ? UniversalPlatformType.Linux
                      : UniversalPlatform.isMacOS
                          ? UniversalPlatformType.MacOS
                          : UniversalPlatformType.Web;
}
