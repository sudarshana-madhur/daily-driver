import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff536600),
      surfaceTint: Color(0xff536600),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd4ff00),
      onPrimaryContainer: Color(0xff5f7400),
      secondary: Color(0xff151616),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2a2a2a),
      onSecondaryContainer: Color(0xff929191),
      tertiary: Color(0xff292929),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3f3f3f),
      onTertiaryContainer: Color(0xffacaaaa),
      error: Color(0xffbc000a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffe2241f),
      onErrorContainer: Color(0xfffffbff),
      surface: Color(0xfffdf8f8),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xff747878),
      outlineVariant: Color(0xffc4c7c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffb0d500),
      primaryFixed: Color(0xffcaf300),
      onPrimaryFixed: Color(0xff171e00),
      primaryFixedDim: Color(0xffb0d500),
      onPrimaryFixedVariant: Color(0xff3e4c00),
      secondaryFixed: Color(0xffe4e2e1),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc8c6c5),
      onSecondaryFixedVariant: Color(0xff474746),
      tertiaryFixed: Color(0xffe4e2e1),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc8c6c6),
      onTertiaryFixedVariant: Color(0xff474747),
      surfaceDim: Color(0xffddd9d8),
      surfaceBright: Color(0xfffdf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3f2),
      surfaceContainer: Color(0xfff1edec),
      surfaceContainerHigh: Color(0xffebe7e6),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2f3b00),
      surfaceTint: Color(0xff536600),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff607500),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff151616),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2a2a2a),
      onSecondaryContainer: Color(0xffb8b6b5),
      tertiary: Color(0xff292929),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3f3f3f),
      onTertiaryContainer: Color(0xffd5d3d3),
      error: Color(0xff740003),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffd71a18),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf8f8),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff333737),
      outline: Color(0xff505354),
      outlineVariant: Color(0xff6a6e6e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffb0d500),
      primaryFixed: Color(0xff607500),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff4b5b00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6e6d6d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff555554),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6d6d6d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff555555),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc9c6c5),
      surfaceBright: Color(0xfffdf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3f2),
      surfaceContainer: Color(0xffebe7e6),
      surfaceContainerHigh: Color(0xffe0dcdb),
      surfaceContainerHighest: Color(0xffd4d1d0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff263000),
      surfaceTint: Color(0xff536600),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff404f00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff151616),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2a2a2a),
      onSecondaryContainer: Color(0xffe4e2e1),
      tertiary: Color(0xff292929),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3f3f3f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff610002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff980006),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf8f8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292d2d),
      outlineVariant: Color(0xff464a4a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffb0d500),
      primaryFixed: Color(0xff404f00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2c3700),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff494949),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff333333),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff494949),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff323333),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb8b7),
      surfaceBright: Color(0xfffdf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f0ef),
      surfaceContainer: Color(0xffe5e2e1),
      surfaceContainerHigh: Color(0xffd7d4d3),
      surfaceContainerHighest: Color(0xffc9c6c5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffb0d500),
      onPrimary: Color(0xff2a3400),
      primaryContainer: Color(0xffcaf300),
      onPrimaryContainer: Color(0xff596c00),
      secondary: Color(0xffc8c6c5),
      onSecondary: Color(0xff303030),
      secondaryContainer: Color(0xff2a2a2a),
      onSecondaryContainer: Color(0xff929191),
      tertiary: Color(0xffc8c6c6),
      onTertiary: Color(0xff303030),
      tertiaryContainer: Color(0xff3f3f3f),
      onTertiaryContainer: Color(0xffacaaaa),
      error: Color(0xffffb4aa),
      onError: Color(0xff690003),
      errorContainer: Color(0xffff5545),
      onErrorContainer: Color(0xff4b0001),
      surface: Color(0xff141313),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color(0xffc4c7c7),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff536600),
      primaryFixed: Color(0xffcaf300),
      onPrimaryFixed: Color(0xff171e00),
      primaryFixedDim: Color(0xffb0d500),
      onPrimaryFixedVariant: Color(0xff3e4c00),
      secondaryFixed: Color(0xffe4e2e1),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc8c6c5),
      onSecondaryFixedVariant: Color(0xff474746),
      tertiaryFixed: Color(0xffe4e2e1),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc8c6c6),
      onTertiaryFixedVariant: Color(0xff474747),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2b2a2a),
      surfaceContainerHighest: Color(0xff353434),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffb0d500),
      onPrimary: Color(0xff2a3400),
      primaryContainer: Color(0xffcaf300),
      onPrimaryContainer: Color(0xff3f4e00),
      secondary: Color(0xffdedcdb),
      onSecondary: Color(0xff252626),
      secondaryContainer: Color(0xff929090),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffdedcdb),
      onTertiary: Color(0xff252626),
      tertiaryContainer: Color(0xff919090),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540002),
      errorContainer: Color(0xffff5545),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadddd),
      outline: Color(0xffafb2b3),
      outlineVariant: Color(0xff8e9191),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff3f4e00),
      primaryFixed: Color(0xffcaf300),
      onPrimaryFixed: Color(0xff0e1300),
      primaryFixedDim: Color(0xffb0d500),
      onPrimaryFixedVariant: Color(0xff2f3b00),
      secondaryFixed: Color(0xffe4e2e1),
      onSecondaryFixed: Color(0xff111111),
      secondaryFixedDim: Color(0xffc8c6c5),
      onSecondaryFixedVariant: Color(0xff363636),
      tertiaryFixed: Color(0xffe4e2e1),
      onTertiaryFixed: Color(0xff111111),
      tertiaryFixedDim: Color(0xffc8c6c6),
      onTertiaryFixedVariant: Color(0xff363636),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff454444),
      surfaceContainerLowest: Color(0xff080707),
      surfaceContainerLow: Color(0xff1e1d1d),
      surfaceContainer: Color(0xff282827),
      surfaceContainerHigh: Color(0xff333232),
      surfaceContainerHighest: Color(0xff3e3d3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffb0d500),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffcaf300),
      onPrimaryContainer: Color(0xff242e00),
      secondary: Color(0xfff2efef),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc4c2c2),
      onSecondaryContainer: Color(0xff0b0b0b),
      tertiary: Color(0xfff2efef),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc4c2c2),
      onTertiaryContainer: Color(0xff0b0b0b),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea3),
      onErrorContainer: Color(0xff220000),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef0f1),
      outlineVariant: Color(0xffc0c3c3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff3f4e00),
      primaryFixed: Color(0xffcaf300),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb0d500),
      onPrimaryFixedVariant: Color(0xff0e1300),
      secondaryFixed: Color(0xffe4e2e1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc8c6c5),
      onSecondaryFixedVariant: Color(0xff111111),
      tertiaryFixed: Color(0xffe4e2e1),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc8c6c6),
      onTertiaryFixedVariant: Color(0xff111111),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff51504f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f1f),
      surfaceContainer: Color(0xff313030),
      surfaceContainerHigh: Color(0xff3c3b3b),
      surfaceContainerHighest: Color(0xff484646),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
