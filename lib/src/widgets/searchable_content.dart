import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

part 'searchbox.dart';

class _SearchableContentScope extends InheritedWidget {
  final SearchableContentState state;
  const _SearchableContentScope({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _SearchableContentScope oldWidget) =>
      state != oldWidget.state;
}

class SearchableContent extends StatefulWidget {
  final Widget child;

  final Duration? debounceDuration;
  final VoidCallback? onDebounceStart;
  final ValueChanged<String>? onChanged;

  const SearchableContent({
    super.key,
    this.onChanged,
    required this.child,
  })  : debounceDuration = null,
        onDebounceStart = null;

  const SearchableContent.debounce({
    super.key,
    this.onChanged,
    Duration this.debounceDuration = const Duration(milliseconds: 100),
    this.onDebounceStart,
    required this.child,
  });

  @override
  State<SearchableContent> createState() => SearchableContentState();

  static SearchableContentState? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_SearchableContentScope>()
      ?.state;

  static SearchableContentState of(BuildContext context) => maybeOf(context)!;
}

class SearchableContentState extends State<SearchableContent>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _textEditingController;

  final ValueNotifier<String> searchText = ValueNotifier("");

  bool _debounced = false;

  @override
  void initState() {
    super.initState();

    _textEditingController = TextEditingController()
      ..addListener(_onInternalControllerChanged);
  }

  @override
  void dispose() {
    _textEditingController
      ..removeListener(_onInternalControllerChanged)
      ..dispose();
    super.dispose();
  }

  void reset() {
    _textEditingController.clear();
    _setSearchText("");
  }

  void _setSearchText(String text) {
    searchText.value = text;
    widget.onChanged?.call(text);
  }

  void _onInternalControllerChanged() {
    final text = _textEditingController.text;
    if (text != searchText.value) {
      if (widget.debounceDuration == null) {
        _setSearchText(text);
      } else {
        if (!_debounced && text.isNotEmpty) {
          widget.onDebounceStart?.call();
          _debounced = true;
        }
        debounce(
          () {
            _debounced = false;
            _setSearchText(text);
          },
          unique: "searchable_scope",
          duration: text.isEmpty ? Duration.zero : widget.debounceDuration!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SearchableContentScope(
      state: this,
      child: widget.child,
    );
  }
}
