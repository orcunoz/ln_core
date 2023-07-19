/*import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class CustomError extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;
  final bool card;
  final Function()? onPressRetry;
  final List<Widget> actionButtons;

  CustomError({
    super.key,
    required BuildContext context,
    this.icon = Icons.error_outline_rounded,
    required this.message,
    this.onPressRetry,
    this.actionButtons = const [],
    this.card = false,
  }) : iconColor = Theme.of(context).colorScheme.error;

  static CustomError autoDetech({
    required BuildContext context,
    Function()? onPressRetry,
    List<Widget> actionButtons = const [],
    required Object? error,
    bool card = false,
  }) {
    if (error != null) {
      if (error is UserFriendlyException) {
        if (error.statusCode == 401) {
          return CustomError.unauthorized(
            context: context,
            message: error.message,
            onPressRetry: onPressRetry,
            actionButtons: actionButtons,
            card: card,
          );
        } else if (error.statusCode == 404) {
          return CustomError.noResultsFound(
            context: context,
            card: card,
            actionButtons: actionButtons,
          );
        } else {
          return CustomError(
            context: context,
            message: error.message,
            onPressRetry: onPressRetry,
            actionButtons: actionButtons,
            card: card,
          );
        }
      }
    }

    return CustomError.somethingWentWrong(
      context: context,
      onPressRetry: onPressRetry,
      actionButtons: actionButtons,
      card: card,
    );
  }

  CustomError.somethingWentWrong({
    super.key,
    required BuildContext context,
    this.onPressRetry,
    this.actionButtons = const [],
    this.card = true,
  })  : icon = Icons.error_outline_rounded,
        iconColor = Theme.of(context).colorScheme.error,
        message =
            "Bir şeyler ters gitti!"; // TODO: S.current.customErrorSomethingWentWrong;

  CustomError.noResultsFound({
    super.key,
    String? message,
    required BuildContext context,
    this.actionButtons = const [],
    this.card = true,
  })  : icon = Icons.web_asset_off_rounded,
        iconColor = Theme.of(context).hintColor,
        message = message ??
            "Hiçbir sonuç bulunamadı!", // TODO: S.current.customErrorNoResultsFound,
        onPressRetry = null;

  CustomError.unauthorized({
    super.key,
    required BuildContext context,
    this.onPressRetry,
    this.actionButtons = const [],
    String? message,
    this.card = true,
  })  : icon = Icons.lock_person_outlined,
        iconColor = Colors.yellow,
        message = message ??
            "Yetkisiz erişim denemesi!"; //S.current.customErrorUnauthorizedAccess;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var messageTextStyle = theme.textTheme.titleMedium ?? const TextStyle();
    var child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
      child: SpacedColumn(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor,
          ),
          Text(
            message,
            style: messageTextStyle,
          ),
          if (actionButtons.isNotEmpty)
            Wrap(
              children: actionButtons,
            )
          else if (onPressRetry != null)
            TextButton.icon(
              icon: Icon(
                Icons.refresh_rounded,
                color: messageTextStyle.color,
              ),
              label: Text(
                MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
                style: TextStyle(color: messageTextStyle.color),
              ),
              onPressed: onPressRetry,
            ),
        ],
      ),
    );
    return card ? Card(child: child) : child;
  }
}
*/