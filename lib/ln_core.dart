library;

import 'package:flutter/material.dart';

export 'src/ln_state.dart';

export 'src/localization/localizations_delegate.dart';
export 'src/localization/localizations_base.dart';
export 'src/localization/localizations.dart';

export 'src/utils/date_time_utils.dart';
export 'src/utils/device_utils.dart';
export 'src/utils/file_utils.dart';
export 'src/utils/layout_utils.dart';
export 'src/utils/logger.dart';
export 'src/utils/regex_utils.dart';
export 'src/utils/string_utils.dart';

export 'src/utils/styling/common.dart';
export 'src/utils/styling/borders.dart';
export 'src/utils/styling/shadows.dart';

export 'src/widgets/backdrop.dart';
export 'src/widgets/copyable_card.dart';
export 'src/widgets/dots_indicator.dart';
export 'src/widgets/draggable_app_bar.dart';
export 'src/widgets/elevated_image.dart';
export 'src/widgets/glass_morphism_card.dart';
export 'src/widgets/highlight_text.dart';
export 'src/widgets/html_content.dart';
export 'src/widgets/measurable.dart';
export 'src/widgets/precision_divider.dart';
export 'src/widgets/progress_indicator_icon.dart';
export 'src/widgets/progress_indicator_layer.dart';
export 'src/widgets/progress_indicator_widget.dart';
export 'src/widgets/responsive.dart';
export 'src/widgets/selectable_card.dart';
export 'src/widgets/settings.dart';
export 'src/widgets/vertical_text.dart';
export 'src/widgets/window_icons.dart';

export 'src/models/wrapped.dart';

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
