import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class SearchTextBox extends StatelessWidget implements PreferredSizeWidget {
  const SearchTextBox({
    super.key,
    this.fillColor,
    this.foregroundColor,
    this.enabled = true,
    this.shrinkWhenDisabled = true,
    this.borderRadius,
    this.border,
    this.autofocus = false,
    this.progressIndicatorIcon = false,
    this.progressIndicatorUnderline = true,
    this.constraints = const BoxConstraints.expand(height: 56),
  }) : assert(border == null || borderRadius == null);

  final Color? fillColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final InputBorder? border;
  final bool progressIndicatorIcon;
  final bool progressIndicatorUnderline;
  final bool enabled;
  final bool autofocus;
  final bool shrinkWhenDisabled;
  final BoxConstraints? constraints;

  @override
  Size get preferredSize => Size.fromHeight(kMinInteractiveDimension);

  Widget _buildPrefixIcon(
    String searchText,
    bool debounced,
    Color foregroundColor,
    VoidCallback onBackPressed,
  ) {
    Widget result = Icon(
      searchText.isEmpty ? Icons.search_rounded : Icons.arrow_back_rounded,
      color: foregroundColor,
    );

    if (progressIndicatorIcon) {
      result = ProgressIndicatorWidget(
        widget: result,
        progress: debounced,
      );
    }

    if (searchText.isNotEmpty) {
      result = IconButton(
        onPressed: onBackPressed,
        icon: result,
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final scopeController = SearchScope.of(context);
    final theme = Theme.of(context);

    final fillColor = this.fillColor ??
        theme.searchBarTheme.backgroundColor?.resolve({
          if (!enabled) MaterialState.disabled,
        }) ??
        theme.tonalScheme.surfaceBrightest;
    final textStyle = (theme.searchBarTheme.textStyle?.resolve({
              if (!enabled) MaterialState.disabled,
            }) ??
            theme.formFieldStyle)
        .copyWith(color: this.foregroundColor);
    final foregroundColor = enabled
        ? textStyle.color ?? fillColor.onColor
        : theme.inputDecorationTheme.hintStyle?.color ?? theme.hintColor;

    final border = this.border ??
        OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
          borderSide: BorderSide.none,
        );

    Widget child = TextField(
      controller: scopeController.textEditingController,
      style: textStyle,
      enabled: enabled,
      autofocus: autofocus,
      textAlignVertical: TextAlignVertical.center,
      expands: constraints?.maxHeight.isInfinite == false,
      maxLines: null,
      decoration: InputDecoration(
        isCollapsed: true,
        fillColor: fillColor,
        focusColor: theme.searchBarTheme.backgroundColor
            ?.resolve({MaterialState.focused}),
        hoverColor: theme.searchBarTheme.backgroundColor
            ?.resolve({MaterialState.hovered}),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        prefixIcon: ListenableBuilder(
          listenable: Listenable.merge([
            scopeController,
            scopeController.debounceListenable,
          ]),
          builder: (context, child) => _buildPrefixIcon(
            scopeController.textEditingController.text,
            scopeController.debounced,
            foregroundColor,
            scopeController.clear,
          ),
        ),
        hintText: "${MaterialLocalizations.of(context).searchFieldLabel}...",
        hintStyle: textStyle,
        prefixIconConstraints: BoxConstraints.expand(
          width: kMinInteractiveDimension,
          height: kMinInteractiveDimension,
        ),
        constraints: constraints ??
            BoxConstraints.tightFor(height: kMinInteractiveDimension),
      ),
    );

    if (progressIndicatorUnderline &&
        scopeController.debounceListenable != null) {
      double linearProgressIndicatorHeight = theme.isLight ? 3 : 2;
      child = Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: linearProgressIndicatorHeight,
            child: ValueListenableBuilder(
              valueListenable: scopeController.debounceListenable!,
              builder: (context, debounced, child) {
                return Offstage(
                  offstage: !debounced,
                  child: child!,
                );
              },
              child: ClipRRect(
                borderRadius: borderRadius ??
                    BorderRadius.circular(kMinInteractiveDimension / 2),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: theme.progressIndicatorTheme.color,
                  minHeight: linearProgressIndicatorHeight,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (shrinkWhenDisabled) {
      child = AnimatedSlideShrink(
        shrinked: !enabled,
        slideDirection: AxisDirection.up,
        duration: const Duration(milliseconds: 500),
        child: child,
      );
    }

    return child;
  }
}
