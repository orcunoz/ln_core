import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class SettingsGroup extends StatelessWidget {
  final String? title;
  final List<SettingsRow> rows;
  final EdgeInsets rowPadding;

  const SettingsGroup({
    super.key,
    this.title,
    required this.rows,
    this.rowPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(
              left: rowPadding.left,
              bottom: 4,
            ),
            child: Text(
              title!,
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              for (var row in rows)
                InkWell(
                  onTap: row.onPressed == null
                      ? null
                      : () => row.onPressed!(context),
                  child: Padding(
                    padding: rowPadding,
                    child: row,
                  ),
                ),
            ].separated(
              seperator: const Divider(height: .5, thickness: .5),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsRow extends StatelessWidget {
  final String titleText;
  final IconData leadingIcon;
  final String? trailingText;
  final Widget? trailing;
  final IconData? trailingIcon;
  final Function(BuildContext)? onPressed;

  const SettingsRow({
    super.key,
    required this.titleText,
    required this.leadingIcon,
    this.trailingText,
    this.trailing,
    //super.description,
    this.onPressed,
    this.trailingIcon,
  }) : assert(trailing == null || trailingText == null);

  const SettingsRow.navigation({
    super.key,
    required this.titleText,
    required this.leadingIcon,
    this.trailingText,
    this.trailing,
    //super.description,
    this.onPressed,
  })  : trailingIcon = Icons.keyboard_arrow_right_rounded,
        assert(trailing == null || trailingText == null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconTheme(
          data: IconThemeData(color: theme.hintColor, size: 22),
          child: Icon(leadingIcon),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DefaultTextStyle(
            style: theme.textTheme.bodyMedium ?? const TextStyle(),
            child: Text(titleText),
          ),
        ),
        if (trailing != null || trailingText != null)
          DefaultTextStyle(
            style:
                theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor) ??
                    const TextStyle(),
            child: trailing ?? Text(trailingText!),
          ),
        if (trailingIcon != null)
          IconTheme(
            data: IconThemeData(color: theme.hintColor, size: 22),
            child: Icon(trailingIcon),
          ),
      ],
    );
  }
}
