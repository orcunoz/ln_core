import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

const _kRowPadding = EdgeInsets.all(16);

BorderRadius _resolveRowBorderRadius(ThemeData theme) {
  return theme.cardTheme.shape?.borderRadius?.resolve(TextDirection.ltr) ??
      BorderRadius.circular(4);
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    this.title,
    required this.rows,
    this.elevation = 1,
  });

  final String? title;
  final List<Widget> rows;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rowBorderRadius = _resolveRowBorderRadius(theme);
    final surfaceColor = theme.surfaces.frontSurfaceColor;

    Widget result = LnSurface(
      LnSurfaceDecoration(color: surfaceColor),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SeparatedColumn(
          separator: PrecisionDivider(
            indent: rowBorderRadius.topLeft.x,
            endIndent: rowBorderRadius.topRight.x,
            color: theme.borderColor(surfaceColor, sharpness: 4),
          ),
          children: rows,
        ),
      ),
    );

    if (title != null) {
      result = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: _kRowPadding.copyWith(top: 0, bottom: 0) +
                const EdgeInsets.only(bottom: 4),
            child: Text(
              title!,
              style: theme.textTheme.labelLarge!.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(child: result),
        ],
      );
    }

    return result;
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

  final String titleText;
  final IconData leadingIcon;
  final String? trailingText;
  final Widget? trailing;
  final IconData? trailingIcon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = _resolveRowBorderRadius(theme);
    final variantColor = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: kMinInteractiveDimension),
        child: Padding(
          padding: _kRowPadding,
          child: Row(
            children: [
              Icon(leadingIcon, color: variantColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titleText,
                  style: theme.textTheme.bodyMedium?.apply(fontSizeFactor: 1.1),
                ),
              ),
              if (trailing != null || trailingText != null)
                DefaultTextStyle(
                  style: (theme.textTheme.bodyMedium ?? const TextStyle())
                      .copyWith(color: variantColor),
                  child: trailing ?? Text(trailingText!),
                ),
              if (trailingIcon != null)
                Icon(trailingIcon, color: variantColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
