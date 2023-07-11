import 'package:flutter/material.dart';

export 'exceptions/network_exceptions.dart';

export 'utils/date_time_utils.dart';
export 'utils/file_utils.dart';
export 'utils/layout_utils.dart';
export 'utils/regex_utils.dart';
export 'utils/string_utils.dart';
export 'utils/styling_utils.dart';

export 'widgets/action_box.dart';
export 'widgets/custom_error.dart';
export 'widgets/elevated_image.dart';
export 'widgets/glass_morphism_card.dart';
export 'widgets/highlight_text.dart';
export 'widgets/html_content.dart';
export 'widgets/measure_size.dart';
export 'widgets/progress_indicator_button.dart';
export 'widgets/progress_indicator_icon.dart';
export 'widgets/responsive.dart';
export 'widgets/settings.dart';

const smallLayoutThreshold = 600.0;
const largeLayoutThreshold = 1200.0;

const formVerticalSpacing = 14.0;
const formHorizontalSpacing = 8.0;

const EdgeInsets listPadding = EdgeInsets.symmetric(
  vertical: 8,
  horizontal: 8,
);

const EdgeInsets formMargin = EdgeInsets.all(12);
const EdgeInsets formPadding = EdgeInsets.symmetric(
  vertical: 22,
  horizontal: 18,
);
