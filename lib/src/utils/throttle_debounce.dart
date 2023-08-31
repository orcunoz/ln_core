import "dart:async";

import "package:stack_trace/stack_trace.dart";

import "dynamic_function.dart";

extension ThrottleDebounceFunctionExtensions<T extends Function> on T {
  dynamic get throttled => DynamicCallHandler<T>((args, [kwargs]) {
        throttle(() => Function.apply(this, args, kwargs),
            unique: Trace.current(1).frames[0].location);
      });

  dynamic get debounced => DynamicCallHandler<T>((args, [kwargs]) {
        debounce(() => Function.apply(this, args, kwargs),
            unique: Trace.current(1).frames[0].location);
      });
}

Map<Object, Timer> _throttles = <Object, Timer>{};
Map<Object, Timer> _debounces = <Object, Timer>{};

void throttle(
  Function fn, {
  Duration duration = const Duration(milliseconds: 350),
  required Object unique,
}) =>
    _throttles.putIfAbsent(unique, () {
      fn();
      return Timer(duration, () => _throttles.remove(unique)?.cancel());
    });

void debounce(
  Function fn, {
  Duration duration = const Duration(milliseconds: 350),
  required Object unique,
}) {
  whenTimeIsUp() {
    _debounces.remove(unique)?.cancel();
    fn();
  }

  if (duration == Duration.zero) {
    whenTimeIsUp();
  } else {
    _debounces
      ..[unique]?.cancel()
      ..[unique] = Timer(duration, whenTimeIsUp);
  }
}
