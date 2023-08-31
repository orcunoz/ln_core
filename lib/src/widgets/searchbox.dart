part of 'searchable_content.dart';

typedef OnSearchTextChanged = void Function(String searchText);

class SearchBox extends StatefulWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? fillColor;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final OnSearchTextChanged? onSearchTextChanged;
  final BorderRadius? borderRadius;
  final bool bottomBorder;

  const SearchBox({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.fillColor,
    this.padding,
    this.textStyle,
    this.onSearchTextChanged,
    this.borderRadius = BorderRadius.zero,
    this.bottomBorder = false,
  }) : assert(textStyle == null || foregroundColor == null);

  @override
  State<SearchBox> createState() => _SearchBoxState();

  @override
  Size get preferredSize => Size.fromHeight(kMinInteractiveDimension);
}

class _SearchBoxState extends State<SearchBox> {
  bool _isEmpty = true;
  TextEditingController? _registeredController;

  TextEditingController? _getScopeController(BuildContext context) {
    final controller = SearchableContent.of(context)._textEditingController;
    if (_registeredController != controller) {
      _registeredController?.removeListener(_handleControllerChanged);
      controller.addListener(_handleControllerChanged);

      _registeredController = controller;
    }

    return _registeredController;
  }

  void _handleControllerChanged() {
    final controllerIsEmpty = _registeredController?.text.isEmpty ?? true;
    if (controllerIsEmpty != _isEmpty) {
      setState(() {
        _isEmpty = controllerIsEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textStyle = widget.textStyle ??
        theme.defaultFormFieldStyle.copyWith(color: widget.foregroundColor);
    final foregroundColor = widget.foregroundColor ??
        textStyle.color ??
        widget.backgroundColor?.onColor ??
        theme.colorScheme.onBackground;
    final backgroundColor =
        widget.backgroundColor ?? theme.colorScheme.background;

    final textFieldBorder = theme.inputDecorationTheme.defaultBorder
        ?.copyWithBorderRadius(borderRadius: widget.borderRadius);

    final controller = _getScopeController(context);

    final textField = TextField(
      cursorColor: foregroundColor,
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
        contentPadding: widget.padding,
        prefixIcon: _isEmpty
            ? Icon(
                Icons.search_rounded,
                color: foregroundColor,
              )
            : IconButton(
                onPressed: () {
                  controller?.clear();
                },
                icon: Icon(Icons.arrow_back_rounded),
              ),
        hintText: "${MaterialLocalizations.of(context).searchFieldLabel}...",
        hintStyle: TextStyle(
          color: foregroundColor.withOpacity(0.7),
        ),
        border: textFieldBorder,
        enabledBorder: textFieldBorder,
        focusedBorder: textFieldBorder,
        fillColor: backgroundColor,
      ),
    );

    if (widget.bottomBorder) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border(
            bottom: BorderSide(
              width: .5,
              color: theme.dividerColor,
            ),
          ),
        ),
        child: textField,
      );
    } else {
      return textField;
    }
  }
}
