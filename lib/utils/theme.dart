import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff705d00),
      surfaceTint: Color(0xff705d00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdb4e),
      onPrimaryContainer: Color(0xff534400),
      secondary: Color(0xff000000),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff262527),
      onSecondaryContainer: Color(0xffb3b0b2),
      tertiary: Color(0xff505050),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff747474),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff9c0011),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffd32f2f),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xff747878),
      outlineVariant: Color(0xffc4c7c8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffeac300),
      primaryFixed: Color(0xffffe174),
      onPrimaryFixed: Color(0xff221b00),
      primaryFixedDim: Color(0xffeac300),
      onPrimaryFixedVariant: Color(0xff554500),
      secondaryFixed: Color(0xffe5e1e3),
      onSecondaryFixed: Color(0xff1c1b1d),
      secondaryFixedDim: Color(0xffc9c6c7),
      onSecondaryFixedVariant: Color(0xff474648),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff464747),
      surfaceDim: Color(0xffddd9d9),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f2),
      surfaceContainer: Color(0xfff1edec),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff504200),
      surfaceTint: Color(0xff705d00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8a7300),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff000000),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff262527),
      onSecondaryContainer: Color(0xffdfdcdd),
      tertiary: Color(0xff424343),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff747474),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8b000e),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffd32f2f),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff404344),
      outline: Color(0xff5c6060),
      outlineVariant: Color(0xff787b7c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffeac300),
      primaryFixed: Color(0xff8a7300),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6e5a00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff767476),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5d5b5d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff747474),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5c5c5c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffddd9d9),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f2),
      surfaceContainer: Color(0xfff1edec),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2a2100),
      surfaceTint: Color(0xff705d00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff504200),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff000000),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff262527),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff212222),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff424343),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8b000e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff212525),
      outline: Color(0xff404344),
      outlineVariant: Color(0xff404344),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffffebac),
      primaryFixed: Color(0xff504200),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff362c00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff434244),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2d2c2e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff424343),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2c2d2d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffddd9d9),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f2),
      surfaceContainer: Color(0xfff1edec),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffeac300),
      onPrimary: Color(0xff3b2f00),
      primaryContainer: Color(0xfffad100),
      onPrimaryContainer: Color(0xff4c3e00),
      secondary: Color(0xffc9c6c7),
      onSecondary: Color(0xff313032),
      secondaryContainer: Color(0xff030304),
      onSecondaryContainer: Color(0xff999799),
      tertiary: Color(0xffc7c6c6),
      onTertiary: Color(0xff303031),
      tertiaryContainer: Color(0xff717171),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb3ac),
      onError: Color(0xff680008),
      errorContainer: Color(0xffc72528),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xff141313),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color(0xffc4c7c8),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff705d00),
      primaryFixed: Color(0xffffe174),
      onPrimaryFixed: Color(0xff221b00),
      primaryFixedDim: Color(0xffeac300),
      onPrimaryFixedVariant: Color(0xff554500),
      secondaryFixed: Color(0xffe5e1e3),
      onSecondaryFixed: Color(0xff1c1b1d),
      secondaryFixedDim: Color(0xffc9c6c7),
      onSecondaryFixedVariant: Color(0xff474648),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff464747),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
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
      surfaceTint: Color(0xffeac300),
      onPrimary: Color(0xff3b2f00),
      primaryContainer: Color(0xfffad100),
      onPrimaryContainer: Color(0xff271f00),
      secondary: Color(0xffcdcacc),
      onSecondary: Color(0xff161618),
      secondaryContainer: Color(0xff929092),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffcbcaca),
      onTertiary: Color(0xff151617),
      tertiaryContainer: Color(0xff919090),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab3),
      onError: Color(0xff370002),
      errorContainer: Color(0xffff544e),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141313),
      onSurface: Color(0xfffefaf9),
      onSurfaceVariant: Color(0xffc8cbcc),
      outline: Color(0xffa0a3a4),
      outlineVariant: Color(0xff808484),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff564700),
      primaryFixed: Color(0xffffe174),
      onPrimaryFixed: Color(0xff161100),
      primaryFixedDim: Color(0xffeac300),
      onPrimaryFixedVariant: Color(0xff413500),
      secondaryFixed: Color(0xffe5e1e3),
      onSecondaryFixed: Color(0xff111112),
      secondaryFixedDim: Color(0xffc9c6c7),
      onSecondaryFixedVariant: Color(0xff373637),
      tertiaryFixed: Color(0xffe3e2e2),
      onTertiaryFixed: Color(0xff101112),
      tertiaryFixedDim: Color(0xffc7c6c6),
      onTertiaryFixedVariant: Color(0xff353636),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353434),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffeac300),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xfffad100),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffdfafc),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffcdcacc),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffcfafa),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffcbcaca),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab3),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff8fbfc),
      outline: Color(0xffc8cbcc),
      outlineVariant: Color(0xffc8cbcc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff332900),
      primaryFixed: Color(0xffffe68f),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffefc800),
      onPrimaryFixedVariant: Color(0xff1c1600),
      secondaryFixed: Color(0xffe9e6e8),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffcdcacc),
      onSecondaryFixedVariant: Color(0xff161618),
      tertiaryFixed: Color(0xffe8e6e6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcbcaca),
      onTertiaryFixedVariant: Color(0xff151617),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353434),
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
