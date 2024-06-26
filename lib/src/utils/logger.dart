import 'dart:convert';

import 'package:ln_core/ln_core.dart';
import 'dart:math';

final Logger _logger =
    Logger(printer: HybridPrinter(SimplePrinter(), error: PrettyPrinter()));

final Logger _coloredLogger = Logger(
    printer: HybridPrinter(LnPrinter(color: AnsiColor.fg(33)), error: null));

class Log {
  static void i(dynamic message) {
    _logger.i(_messageWithTime(message));
  }

  static void w(dynamic message) {
    _logger.w(_messageWithTime(message));
  }

  static void d(dynamic message) {
    _logger.d(_messageWithTime(message));
  }

  static void e(dynamic errorOrMessage, {StackTrace? stackTrace}) {
    Error? error = errorOrMessage is Error ? errorOrMessage : null;

    if (stackTrace != null) {
      _logger.e(errorOrMessage, error: errorOrMessage, stackTrace: stackTrace);
    }
    _logger.e(errorOrMessage, error: error);
  }

  static void fatal(dynamic message) {
    _logger.f(_messageWithTime(message));
  }

  static void colored(String part1, String part2) {
    _coloredLogger.d("$part1.$part2");
  }

  static String _messageWithTime(dynamic message) {
    return "${DateTime.now().toTimeString()}: $message";
  }
}

class LnPrinter extends LogPrinter {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';

  final timeColor = AnsiColor.fg(AnsiColor.grey(0.5));

  static DateTime? _startTime;
  final int stackTraceBeginIndex;
  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final AnsiColor color;
  final bool printTime;
  final bool includeBox;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  LnPrinter({
    this.stackTraceBeginIndex = 0,
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    AnsiColor? color,
    this.printTime = true,
    this.includeBox = false,
  }) : color = color ?? AnsiColor.fg(23) {
    _startTime ??= DateTime.now();

    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();
    for (var i = 0; i < lineLength - 1; i++) {
      doubleDividerLine.write(doubleDivider);
      singleDividerLine.write(singleDivider);
    }

    _topBorder = '$topLeftCorner$doubleDividerLine';
    _middleBorder = '$middleCorner$singleDividerLine';
    _bottomBorder = '$bottomLeftCorner$doubleDividerLine';
  }

  @override
  List<String> log(LogEvent event) {
    var messageStr = stringifyMessage(event.message);

    String? timeStr;
    if (printTime) {
      timeStr = getTime(DateTime.now(), true);
    }

    return _formatAndPrint(
      messageStr,
      timeStr,
      null, //errorStr,
      null, //stackTraceStr,
    );
  }

  String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    List<String> lines = stackTrace
        .toString()
        .split('\n')
        .where(
          (line) => line.isNotEmpty,
        )
        .toList();
    List<String> formatted = [];

    for (int count = 0; count < min(lines.length, methodCount); count++) {
      var line = lines[count];
      if (count < stackTraceBeginIndex) {
        continue;
      }
      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  String getTime(DateTime time, bool short) {
    String threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = time;
    var h = twoDigits(now.hour);
    var min = twoDigits(now.minute);
    var sec = twoDigits(now.second);
    var ms = threeDigits(now.millisecond);
    var timeSinceStart = now.difference(_startTime!).toString();
    return short ? '$h:$min:$sec' : '$h:$min:$sec.$ms (+$timeSinceStart)';
  }

  // Handles any object that is causing JsonEncoder() problems
  Object toEncodableFallback(dynamic object) {
    return object.toString();
  }

  String stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = JsonEncoder.withIndent('  ', toEncodableFallback);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }

  List<String> _formatAndPrint(
      String message, String? time, String? error, String? stacktrace) {
    List<String> buffer = [];
    var verticalLineAtLevel = includeBox ? ('$verticalLine ') : '';
    if (includeBox) buffer.add(color(_topBorder));

    if (error != null) {
      for (var line in error.split('\n')) {
        buffer.add(color('$verticalLineAtLevel$line'));
      }
      if (includeBox) buffer.add(color(_middleBorder));
    }

    if (stacktrace != null) {
      for (var line in stacktrace.split('\n')) {
        buffer.add(color('$verticalLineAtLevel$line'));
      }
      if (includeBox) buffer.add(color(_middleBorder));
    }

    for (var line in message.split('\n')) {
      final prts = line.split('.');
      buffer.add(timeColor('$time: ') +
          color('${prts.first}.') +
          (prts.length > 1 ? prts.sublist(1).join('.') : ''));
    }
    if (includeBox) buffer.add(color(_bottomBorder));

    return buffer;
  }
}
