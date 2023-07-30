import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ln_core/ln_core.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

/// Helper class for device related operations.
///
class DeviceUtils {
  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static Future<void> copyToClipboard(String text) async {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      return;
    } else {
      throw ('Please enter a string');
    }
  }

  static Future<String> pasteFromClipboard() => Clipboard.getData('text/plain')
      .then((data) => data?.text?.toString() ?? "");

  static Future<void> clipboardCopyAndShowSnack(
      BuildContext context, String textToCopy, String message) {
    return copyToClipboard(textToCopy)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 1),
              ),
            ))
        .onError(
            (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 1),
                  ),
                ));
  }

  @Deprecated("Use AnnotatedRegion<SystemUiOverlayStyle> instead this")
  static setStatusBarBrightness(Brightness brightness) {
    if (UniversalPlatform.isAndroid
        ? brightness == Brightness.light
        : brightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent, // Color for Android
          statusBarBrightness:
              Brightness.dark // Dark == white status bar -- for IOS.
          ));
    } else if (UniversalPlatform.isAndroid
        ? brightness == Brightness.dark
        : brightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent, // Color for Android
          statusBarBrightness:
              Brightness.light // Dark == white status bar -- for IOS.
          ));
    }
  }

  static Future<void> initializeDesktopWindow({
    Size? size = const Size(kInitialWindowWidth, kInitialWindowHeight),
    bool? center = true,
    Size? minimumSize = const Size(kMinimumWindowWidth, kMinimumWindowHeight),
    Size? maximumSize,
    bool? alwaysOnTop,
    bool? fullScreen,
    Color? backgroundColor = Colors.transparent,
    bool? skipTaskbar = false,
    String? title,
    TitleBarStyle? titleBarStyle = TitleBarStyle.hidden,
    bool? windowButtonVisibility,
  }) async {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow(WindowOptions(
      size: size,
      center: center,
      minimumSize: minimumSize,
      maximumSize: maximumSize,
      alwaysOnTop: alwaysOnTop,
      fullScreen: fullScreen,
      backgroundColor: backgroundColor,
      skipTaskbar: skipTaskbar,
      title: title,
      titleBarStyle: titleBarStyle,
      windowButtonVisibility: windowButtonVisibility,
    ));
    //await windowManager.setAsFrameless();
    await windowManager.show();
    await windowManager.focus();
  }

  static exitApp() {
    if (UniversalPlatform.isAndroid) {
      SystemNavigator.pop();
    } else if (UniversalPlatform.isIOS || UniversalPlatform.isFuchsia) {
      exit(0);
    } else if (UniversalPlatform.isDesktop) {
      windowManager.close();
    }
  }
}

class DeviceInfo {
  static String platform = _platform();

  late final String? name;
  late final String? version;
  late final String? identifier;

  DeviceInfo._();

  static String _platform() {
    if (UniversalPlatform.isWeb) {
      return "Web";
    } else if (UniversalPlatform.isAndroid) {
      return "Android";
    } else if (UniversalPlatform.isIOS) {
      return "IOS";
    } else if (UniversalPlatform.isWindows) {
      return "Windows";
    } else if (UniversalPlatform.isMacOS) {
      return "MacOS";
    } else if (UniversalPlatform.isLinux) {
      return "Linux";
    } else if (UniversalPlatform.isFuchsia) {
      return "Fuchsia";
    }
    return "Unknown";
  }

  static Future<DeviceInfo> fromDevice() async {
    final DeviceInfo di = DeviceInfo._();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (UniversalPlatform.isWeb) {
        //var data = await deviceInfo.webBrowserInfo;
        di.name = "WebApp";
        di.version = null;
        di.identifier = null;
      } else if (UniversalPlatform.isAndroid) {
        final build = await deviceInfo.androidInfo;
        di.name = build.model;
        di.version = build.version.toString();
        di.identifier = build.id;
      } else if (UniversalPlatform.isIOS) {
        var data = await deviceInfo.iosInfo;
        di.name = data.name;
        di.version = data.systemVersion;
        di.identifier = data.identifierForVendor;
      } else if (UniversalPlatform.isWindows) {
        var data = await deviceInfo.windowsInfo;
        di.name = data.computerName;
        di.version =
            "${data.displayVersion} ${data.majorVersion}.${data.minorVersion} ${data.csdVersion}";
        di.identifier = data.deviceId;
      } else if (UniversalPlatform.isMacOS) {
        var data = await deviceInfo.macOsInfo;
        di.name = data.computerName;
        di.version = "${data.osRelease} ${data.model} ${data.kernelVersion}";
        di.identifier = data.systemGUID;
      } else if (UniversalPlatform.isLinux) {
        var data = await deviceInfo.linuxInfo;
        di.name = data.name;
        di.version = "${data.versionCodename} ${data.version}";
        di.identifier = data.machineId;
      }
    } on PlatformException {
      Log.e('Failed to get platform version');
    }

    return di;
  }
}
