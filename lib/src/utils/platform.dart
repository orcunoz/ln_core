import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_platform/universal_platform.dart';

abstract class LnPlatform {
  const LnPlatform._();

  static Brightness get brightness =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  static Brightness brightnessOf(BuildContext context) =>
      View.of(context).platformDispatcher.platformBrightness;

  static bool get isWeb => UniversalPlatform.isWeb;
  static bool get isMacOS => UniversalPlatform.isMacOS;
  static bool get isWindows => UniversalPlatform.isWindows;
  static bool get isLinux => UniversalPlatform.isLinux;
  static bool get isAndroid => UniversalPlatform.isAndroid;
  static bool get isIOS => UniversalPlatform.isIOS;
  static bool get isFuchsia => UniversalPlatform.isFuchsia;

  static bool get isDesktop => isLinux || isMacOS || isWindows;
  static bool get isDesktopOrWeb => isDesktop || isWeb;

  static final UniversalPlatformType platform = isAndroid
      ? UniversalPlatformType.Android
      : isIOS
          ? UniversalPlatformType.IOS
          : isFuchsia
              ? UniversalPlatformType.Fuchsia
              : isWindows
                  ? UniversalPlatformType.Windows
                  : isLinux
                      ? UniversalPlatformType.Linux
                      : isMacOS
                          ? UniversalPlatformType.MacOS
                          : isWeb
                              ? UniversalPlatformType.Web
                              : throw Exception("Unhandled platform!");
}
