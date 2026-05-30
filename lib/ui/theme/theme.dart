import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4a672d),
      surfaceTint: Color(0xff4a672d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcbeea5),
      onPrimaryContainer: Color(0xff334e17),
      secondary: Color(0xff855318),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdcbe),
      onSecondaryContainer: Color(0xff693c00),
      tertiary: Color(0xff735c0c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffe08a),
      onTertiaryContainer: Color(0xff574400),
      error: Color(0xff904a47),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad7),
      onErrorContainer: Color(0xff733331),
      surface: Color(0xfff9faef),
      onSurface: Color(0xff1a1d16),
      onSurfaceVariant: Color(0xff44483e),
      outline: Color(0xff74796c),
      outlineVariant: Color(0xffc4c8ba),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312a),
      inversePrimary: Color(0xffafd18c),
      primaryFixed: Color(0xffcbeea5),
      onPrimaryFixed: Color(0xff0e2000),
      primaryFixedDim: Color(0xffafd18c),
      onPrimaryFixedVariant: Color(0xff334e17),
      secondaryFixed: Color(0xffffdcbe),
      onSecondaryFixed: Color(0xff2c1600),
      secondaryFixedDim: Color(0xfffcb975),
      onSecondaryFixedVariant: Color(0xff693c00),
      tertiaryFixed: Color(0xffffe08a),
      onTertiaryFixed: Color(0xff241a00),
      tertiaryFixedDim: Color(0xffe2c46d),
      onTertiaryFixedVariant: Color(0xff574400),
      surfaceDim: Color(0xffd9dbd0),
      surfaceBright: Color(0xfff9faef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f5e9),
      surfaceContainer: Color(0xffedefe4),
      surfaceContainerHigh: Color(0xffe8e9de),
      surfaceContainerHighest: Color(0xffe2e3d9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff233d07),
      surfaceTint: Color(0xff4a672d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff58763a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff522d00),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff976126),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff443400),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff836a1c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e2322),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa15855),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9faef),
      onSurface: Color(0xff0f120c),
      onSurfaceVariant: Color(0xff33382d),
      outline: Color(0xff505449),
      outlineVariant: Color(0xff6a6f63),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312a),
      inversePrimary: Color(0xffafd18c),
      primaryFixed: Color(0xff58763a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff405d24),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff976126),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff7a490e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff836a1c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff685200),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6c7bd),
      surfaceBright: Color(0xfff9faef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f5e9),
      surfaceContainer: Color(0xffe8e9de),
      surfaceContainerHigh: Color(0xffdcded3),
      surfaceContainerHighest: Color(0xffd1d3c8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff193200),
      surfaceTint: Color(0xff4a672d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff35511a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff442500),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6c3e02),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff382b00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5a4700),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff511919),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff763533),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9faef),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292e24),
      outlineVariant: Color(0xff464b40),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f312a),
      inversePrimary: Color(0xffafd18c),
      primaryFixed: Color(0xff35511a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff1f3904),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6c3e02),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4d2a00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5a4700),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3f3100),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb8baaf),
      surfaceBright: Color(0xfff9faef),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f2e7),
      surfaceContainer: Color(0xffe2e3d9),
      surfaceContainerHigh: Color(0xffd4d5cb),
      surfaceContainerHighest: Color(0xffc6c7bd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffafd18c),
      surfaceTint: Color(0xffafd18c),
      onPrimary: Color(0xff1d3702),
      primaryContainer: Color(0xff334e17),
      onPrimaryContainer: Color(0xffcbeea5),
      secondary: Color(0xfffcb975),
      onSecondary: Color(0xff4a2800),
      secondaryContainer: Color(0xff693c00),
      onSecondaryContainer: Color(0xffffdcbe),
      tertiary: Color(0xffe2c46d),
      onTertiary: Color(0xff3d2f00),
      tertiaryContainer: Color(0xff574400),
      onTertiaryContainer: Color(0xffffe08a),
      error: Color(0xffffb3af),
      onError: Color(0xff571d1d),
      errorContainer: Color(0xff733331),
      onErrorContainer: Color(0xffffdad7),
      surface: Color(0xff12140e),
      onSurface: Color(0xffe2e3d9),
      onSurfaceVariant: Color(0xffc4c8ba),
      outline: Color(0xff8e9285),
      outlineVariant: Color(0xff44483e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e3d9),
      inversePrimary: Color(0xff4a672d),
      primaryFixed: Color(0xffcbeea5),
      onPrimaryFixed: Color(0xff0e2000),
      primaryFixedDim: Color(0xffafd18c),
      onPrimaryFixedVariant: Color(0xff334e17),
      secondaryFixed: Color(0xffffdcbe),
      onSecondaryFixed: Color(0xff2c1600),
      secondaryFixedDim: Color(0xfffcb975),
      onSecondaryFixedVariant: Color(0xff693c00),
      tertiaryFixed: Color(0xffffe08a),
      onTertiaryFixed: Color(0xff241a00),
      tertiaryFixedDim: Color(0xffe2c46d),
      onTertiaryFixedVariant: Color(0xff574400),
      surfaceDim: Color(0xff12140e),
      surfaceBright: Color(0xff373a33),
      surfaceContainerLowest: Color(0xff0c0f09),
      surfaceContainerLow: Color(0xff1a1d16),
      surfaceContainer: Color(0xff1e211a),
      surfaceContainerHigh: Color(0xff282b24),
      surfaceContainerHighest: Color(0xff33362e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc5e7a0),
      surfaceTint: Color(0xffafd18c),
      onPrimary: Color(0xff152b00),
      primaryContainer: Color(0xff7b9a5a),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd5ae),
      onSecondary: Color(0xff3b1f00),
      secondaryContainer: Color(0xffc08445),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffada80),
      onTertiary: Color(0xff302400),
      tertiaryContainer: Color(0xffa98e3d),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cf),
      onError: Color(0xff481313),
      errorContainer: Color(0xffcb7b77),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff12140e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadecf),
      outline: Color(0xffb0b4a6),
      outlineVariant: Color(0xff8e9285),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e3d9),
      inversePrimary: Color(0xff344f19),
      primaryFixed: Color(0xffcbeea5),
      onPrimaryFixed: Color(0xff071400),
      primaryFixedDim: Color(0xffafd18c),
      onPrimaryFixedVariant: Color(0xff233d07),
      secondaryFixed: Color(0xffffdcbe),
      onSecondaryFixed: Color(0xff1e0d00),
      secondaryFixedDim: Color(0xfffcb975),
      onSecondaryFixedVariant: Color(0xff522d00),
      tertiaryFixed: Color(0xffffe08a),
      onTertiaryFixed: Color(0xff171000),
      tertiaryFixedDim: Color(0xffe2c46d),
      onTertiaryFixedVariant: Color(0xff443400),
      surfaceDim: Color(0xff12140e),
      surfaceBright: Color(0xff43453e),
      surfaceContainerLowest: Color(0xff060804),
      surfaceContainerLow: Color(0xff1c1f18),
      surfaceContainer: Color(0xff262922),
      surfaceContainerHigh: Color(0xff31342c),
      surfaceContainerHighest: Color(0xff3c3f37),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd8fbb2),
      surfaceTint: Color(0xffafd18c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffaccd88),
      onPrimaryContainer: Color(0xff040e00),
      secondary: Color(0xffffeddf),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfff8b571),
      onSecondaryContainer: Color(0xff150800),
      tertiary: Color(0xffffefc9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffdec069),
      onTertiaryContainer: Color(0xff100b00),
      error: Color(0xffffecea),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea9),
      onErrorContainer: Color(0xff220002),
      surface: Color(0xff12140e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef2e3),
      outlineVariant: Color(0xffc0c4b6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e3d9),
      inversePrimary: Color(0xff344f19),
      primaryFixed: Color(0xffcbeea5),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffafd18c),
      onPrimaryFixedVariant: Color(0xff071400),
      secondaryFixed: Color(0xffffdcbe),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfffcb975),
      onSecondaryFixedVariant: Color(0xff1e0d00),
      tertiaryFixed: Color(0xffffe08a),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe2c46d),
      onTertiaryFixedVariant: Color(0xff171000),
      surfaceDim: Color(0xff12140e),
      surfaceBright: Color(0xff4e5149),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e211a),
      surfaceContainer: Color(0xff2f312a),
      surfaceContainerHigh: Color(0xff3a3c35),
      surfaceContainerHighest: Color(0xff454840),
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


  List<ExtendedColor> get extendedColors => [
  ];
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
