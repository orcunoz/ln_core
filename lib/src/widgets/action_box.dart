/*import 'package:flutter/material.dart';

import 'package:ln_core/ln_core.dart';

class ActionBox extends StatelessWidget {
  final String? message;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final EdgeInsetsGeometry margin;
  final bool useDecoration;

  ActionBox.success({
    super.key,
    required BuildContext context,
    required this.message,
    this.margin = EdgeInsets.zero,
    this.useDecoration = true,
  })  : icon = Icons.check_circle_outline_rounded,
        backgroundColor = Colors.green.shade100,
        foregroundColor = Colors.green.shade600;

  ActionBox.error({
    super.key,
    required BuildContext context,
    required this.message,
    this.margin = EdgeInsets.zero,
    this.useDecoration = true,
  })  : icon = Icons.error_outline_rounded,
        backgroundColor = Theme.of(context).colorScheme.errorContainer,
        foregroundColor = Theme.of(context).colorScheme.onErrorContainer;

  static Widget errorAutoDetect({
    required BuildContext context,
    required Object? error,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    bool useDecoration = true,
  }) {
    if (error == null) return const SizedBox();

    if (error is UserFriendlyException) {
      if (error.statusCode == 401) {
        return ActionBox.error(
          context: context,
          message: error.message.isNotEmpty
              ? error.message
              : "Yetkisiz erişim denemesi!", // //S.current.customErrorUnauthorizedAccess;
          margin: margin,
          useDecoration: useDecoration,
        );
      } else if ((error.statusCode ?? 1000) < 500) {
        return ActionBox.error(
          context: context,
          message: error.message,
          margin: margin,
          useDecoration: useDecoration,
        );
      }
    }

    return ActionBox.error(
      context: context,
      message:
          "Bir şeyler ters gitti", // Todo: S.current.customErrorSomethingWentWrong,
      margin: margin,
      useDecoration: useDecoration,
    );
  }

  ActionBox.warning({
    super.key,
    required BuildContext context,
    required this.message,
    this.margin = EdgeInsets.zero,
    this.useDecoration = true,
  })  : icon = Icons.error_outline_rounded,
        backgroundColor = Colors.yellow.shade300,
        foregroundColor = Colors.yellow.shade900;

  ActionBox.info({
    super.key,
    required BuildContext context,
    required this.message,
    this.margin = EdgeInsets.zero,
    this.useDecoration = true,
  })  : icon = Icons.info_outline_rounded,
        backgroundColor =
            Theme.of(context).colorScheme.onBackground.withOpacity(.08),
        foregroundColor = Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.onBackground
            : Theme.of(context).colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: useDecoration
            ? Theme.of(context).cardTheme.shape?.borderRadius?.at(context)
            : null,
        border: useDecoration
            ? Border.all(
                color: backgroundColor.blend(foregroundColor, 20),
                width: 0.5,
              )
            : null,
      ),
      child: SpacedRow(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: foregroundColor,
            size: 30,
          ),
          if (message != null)
            Expanded(
              child: Text(
                message!,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
*/