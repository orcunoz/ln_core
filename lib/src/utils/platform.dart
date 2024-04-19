import 'package:universal_platform/universal_platform.dart';

abstract class LnPlatform {
  const LnPlatform._();

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
