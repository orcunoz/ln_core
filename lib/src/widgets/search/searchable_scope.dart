import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

int _uniqueNumber = 1;

typedef SearchableScopeBuilder = Widget Function(
    BuildContext context, SearchScopeController controller);

class _SearchableScope extends InheritedWidget {
  const _SearchableScope({
    required this.state,
    required super.child,
  });

  final _SearchScopeState state;

  @override
  bool updateShouldNotify(covariant _SearchableScope oldWidget) =>
      state != oldWidget.state;
}

class SearchScope extends StatefulWidget {
  const SearchScope({
    super.key,
    this.debounceDuration = const Duration(milliseconds: 200),
    required Widget this.child,
  }) : builder = null;

  const SearchScope.builder({
    super.key,
    this.debounceDuration = const Duration(milliseconds: 200),
    required SearchableScopeBuilder this.builder,
  }) : child = null;

  final Duration? debounceDuration;
  final SearchableScopeBuilder? builder;
  final Widget? child;

  static SearchScopeController? _rootController;

  @override
  State<SearchScope> createState() {
    return _SearchScopeState();
  }

  static SearchScopeController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_SearchableScope>();
    return scope?.state.controller ??
        (_rootController ??= SearchScopeController());
  }
}

class _SearchScopeState extends State<SearchScope> {
  late final SearchScopeController controller =
      SearchScopeController(debounceDuration: widget.debounceDuration);

  @override
  Widget build(BuildContext context) {
    return _SearchableScope(
      state: this,
      child: widget.builder != null
          ? ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, _) =>
                  widget.builder!(context, controller))
          : widget.child!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class SearchScopeController extends ValueNotifier<String> {
  SearchScopeController({
    String initialSearchText = "",
    this.debounceDuration = const Duration(milliseconds: 400),
  })  : _debounceNotifier =
            debounceDuration == null ? null : ValueNotifier(false),
        super(initialSearchText);

  final int _uniqueNo = _uniqueNumber++;
  final Duration? debounceDuration;

  final ValueNotifier<bool>? _debounceNotifier;
  ValueListenable<bool>? get debounceListenable => _debounceNotifier;
  bool get debounced => _debounceNotifier?.value ?? false;

  TextEditingController? _textEditingController;
  TextEditingController get textEditingController =>
      _textEditingController ??= TextEditingController(text: value)
        ..addListener(_onInternalControllerChanged);

  @override
  set value(String value) {
    bool debounced = value != _textEditingController?.text;
    _debounceNotifier?.value = debounced;
    super.value = value;
  }

  Iterable<T> filter<T>(Iterable<T> list, {List<Object?> Function(T)? fields}) {
    String searchText = value.trim().toLowerCase();
    if (searchText.isEmpty) return list;
    final filteredList = list
        .where((e) =>
            (fields == null ? e.toString() : fields(e).nonNulls.join('|'))
                .toLowerCase()
                .contains(searchText))
        .toList();
    return filteredList;
  }

  void clear() {
    _textEditingController?.clear();
  }

  void _onInternalControllerChanged() {
    if (debounceDuration == null || textEditingController.text.isEmpty) {
      value = textEditingController.text;
    } else {
      debounce(
        () {
          value = textEditingController.text;
        },
        unique: "searchable_scope_$_uniqueNo",
        duration: debounceDuration!,
      );
    }
    _debounceNotifier?.value = value != _textEditingController?.text;
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }
}
