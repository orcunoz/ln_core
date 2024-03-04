typedef OnCall = void Function(List<dynamic>? args,
    [Map<Symbol, dynamic>? kwargs]);

class DynamicCallHandler<T extends Function> {
  final OnCall onCall;

  DynamicCallHandler(this.onCall);

  void call() => onCall([], {});

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return onCall(invocation.positionalArguments, invocation.namedArguments);
  }
}

typedef OnCall2 = void Function(List<dynamic>? args,
    [Map<String, dynamic>? kwargs]);

class DynamicCallHandler2<T extends Function> {
  final OnCall2 onCall;
  static final _offset = 'Symbol("'.length;

  DynamicCallHandler2(this.onCall);

  void call() => onCall([], {});

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return onCall(
      invocation.positionalArguments,
      invocation.namedArguments.map(
        (k, v) {
          var sk = k.toString();
          return MapEntry(sk.substring(_offset, sk.length - 2), v);
        },
      ),
    );
  }
}
