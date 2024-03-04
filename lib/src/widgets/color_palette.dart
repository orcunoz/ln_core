import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class ColorPalette extends StatelessWidget {
  const ColorPalette({super.key, this.theme, this.customColors = const {}});

  final ThemeData? theme;
  final Map<String, MaterialCustomColor> customColors;

  Widget colorBox(
    Color color, {
    double aspectRatio = 1,
    Widget? child,
  }) {
    return Flexible(
      flex: 1,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ColoredBox(
          color: color,
          child: child,
        ),
      ),
    );
  }

  Widget onText(String symbol, Color color, double boxSize) {
    return Center(
      child: Text(
        symbol,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: boxSize / 2,
        ),
      ),
    );
  }

  Widget colorBoxWithOnText(
    Color color,
    Color onColor,
    String symbol,
    double boxSize, {
    double aspectRatio = 1,
  }) {
    return colorBox(
      color,
      aspectRatio: aspectRatio,
      child: onText(symbol, onColor, boxSize / aspectRatio),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = (theme ?? Theme.of(context)).tonalScheme;
    return LayoutBuilder(builder: (_, constraints) {
      final width = constraints.maxWidth.clamp(0, 300);
      return SeparatedColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              colorBoxWithOnText(
                scheme.primary,
                scheme.onPrimary,
                "P",
                width / 3,
              ),
              colorBoxWithOnText(
                scheme.secondary,
                scheme.onSecondary,
                "S",
                width / 3,
              ),
              colorBoxWithOnText(
                scheme.tertiary,
                scheme.onTertiary,
                "T",
                width / 3,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              colorBoxWithOnText(scheme.primaryContainer,
                  scheme.onPrimaryContainer, "Pc", width / 3,
                  aspectRatio: 1.5),
              colorBoxWithOnText(scheme.secondaryContainer,
                  scheme.onSecondaryContainer, "Sc", width / 3,
                  aspectRatio: 1.5),
              colorBoxWithOnText(scheme.tertiaryContainer,
                  scheme.onTertiaryContainer, "Tc", width / 3,
                  aspectRatio: 1.5),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              colorBoxWithOnText(
                scheme.primaryFixed,
                scheme.onPrimaryFixed,
                "Px",
                width / 6,
              ),
              colorBoxWithOnText(
                scheme.primaryFixedDim,
                scheme.onPrimaryFixedVariant,
                "dm",
                width / 6,
              ),
              colorBoxWithOnText(
                scheme.secondaryFixed,
                scheme.onSecondaryFixed,
                "Sx",
                width / 6,
              ),
              colorBoxWithOnText(
                scheme.secondaryFixedDim,
                scheme.onSecondaryFixedVariant,
                "dm",
                width / 6,
              ),
              colorBoxWithOnText(
                scheme.tertiaryFixed,
                scheme.onTertiaryFixed,
                "Tx",
                width / 6,
              ),
              colorBoxWithOnText(
                scheme.tertiaryFixedDim,
                scheme.onTertiaryFixedVariant,
                "dm",
                width / 6,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              colorBoxWithOnText(
                scheme.neutral,
                scheme.onSurface,
                "Ne",
                width / 3,
                aspectRatio: 2,
              ),
              colorBoxWithOnText(
                scheme.neutralVariant,
                scheme.onSurface,
                "NeV",
                width / 3,
                aspectRatio: 2,
              ),
              colorBoxWithOnText(
                scheme.inversePrimary,
                scheme.primary,
                "InvP",
                width / 3,
                aspectRatio: 2,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              colorBoxWithOnText(
                scheme.surfaceDim,
                scheme.onSurface,
                "Dim",
                width / 3,
                aspectRatio: 2,
              ),
              colorBoxWithOnText(
                scheme.surface,
                scheme.onSurface,
                "Sur",
                width / 3,
                aspectRatio: 2,
              ),
              colorBoxWithOnText(
                scheme.surfaceBright,
                scheme.onSurfaceVariant,
                "Bri",
                width / 3,
                aspectRatio: 2,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var level = 1; level <= 5; level++)
                colorBoxWithOnText(
                  scheme.surfaceContainerAt(level),
                  scheme.onSurface,
                  level.toString(),
                  width / 5,
                ),
            ],
          ),
          for (var cc in customColors.entries)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                colorBoxWithOnText(
                  cc.value.color,
                  cc.value.onColor,
                  cc.key.toUpperCase(),
                  width / 4,
                  aspectRatio: 1.5,
                ),
                colorBoxWithOnText(
                  cc.value.container,
                  cc.value.onContainer,
                  "Con",
                  width / 4,
                  aspectRatio: 1.5,
                ),
                colorBoxWithOnText(
                  cc.value.fixed,
                  cc.value.onFixed,
                  "Fix",
                  width / 4,
                  aspectRatio: 1.5,
                ),
                colorBoxWithOnText(
                  cc.value.fixedDim,
                  cc.value.onFixedVariant,
                  "Fdm",
                  width / 4,
                  aspectRatio: 1.5,
                ),
              ],
            ),
        ],
      );
    });
  }
}
