import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

const _kRowInsets = EdgeInsets.all(16);
const _kGroupPadding = EdgeInsets.all(6.0);

class SettingsGroupTitle extends StatelessWidget {
  const SettingsGroupTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: _kRowInsets.copyWith(top: 0, bottom: 0),
      child: Text(
        title,
        style: theme.textTheme.labelMedium!.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    required this.rows,
    this.frameBuilder,
  });

  final List<Widget> rows;
  final Widget Function(BuildContext, Widget)? frameBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = SettingsRow.resolveBorderRadius(theme);

    Widget child = Padding(
      padding: _kGroupPadding,
      child: SeparatedColumn(
        separator: PrecisionDivider(
          indent: borderRadius.topLeft.x,
          endIndent: borderRadius.topRight.x,
          color: theme.colorScheme.onSurfaceVariant.withOpacityFactor(.2),
        ),
        children: rows,
      ),
    );

    if (frameBuilder != null) {
      child = frameBuilder!(context, child);
    }

    return child;
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.titleText,
    required this.leadingIcon,
    this.trailingText,
    this.trailing,
    this.onPressed,
    this.trailingIcon,
  }) : assert(trailing == null || trailingText == null);

  const SettingsRow.navigation({
    super.key,
    required this.titleText,
    required this.leadingIcon,
    this.trailingText,
    this.trailing,
    this.onPressed,
  })  : trailingIcon = Icons.keyboard_arrow_right_rounded,
        assert(trailing == null || trailingText == null);

  const SettingsRow.custom({
    super.key,
    required this.titleText,
    required this.leadingIcon,
    required Widget child,
  })  : trailing = child,
        trailingIcon = null,
        trailingText = null,
        onPressed = null;

  final String titleText;
  final IconData leadingIcon;
  final String? trailingText;
  final Widget? trailing;
  final IconData? trailingIcon;
  final Function()? onPressed;

  static BorderRadius resolveBorderRadius(ThemeData theme) =>
      theme.cardTheme.shape?.borderRadius?.resolve(TextDirection.ltr) ??
      BorderRadius.circular(6);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final variantColor = theme.colorScheme.onSurfaceVariant;
    final borderRadius = resolveBorderRadius(theme);

    return Material(
      type: MaterialType.transparency,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: kMinInteractiveDimension),
          child: Padding(
            padding: _kRowInsets - _kGroupPadding,
            child: Row(
              children: [
                Icon(leadingIcon, color: variantColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    titleText,
                    style:
                        theme.textTheme.bodyMedium?.apply(fontSizeFactor: 1.1),
                  ),
                ),
                if (trailing != null || trailingText != null)
                  DefaultTextStyle(
                    style: (theme.textTheme.bodyMedium ?? const TextStyle())
                        .copyWith(color: variantColor),
                    child: trailing ?? Text(trailingText!),
                  ),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: variantColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
