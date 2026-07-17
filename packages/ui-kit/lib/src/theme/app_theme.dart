import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

extension GlossThemeGetter on BuildContext {
  GlossTheme get gloss => Theme.of(this).extension<GlossTheme>()!;
}

@immutable
class GlossTheme extends ThemeExtension<GlossTheme> {
  final Color green;
  final Color darkGreen;
  final Color bg;
  final Color card;
  final Color surface;
  final Color text;
  final Color hint;
  final Color greenText;
  final Color border;
  final Color disabled;
  final Color divider;
  final Color red;
  final Color orange;
  final Color star;
  final Color greenBgLight;
  final Color greenBgSoft;
  final Color greenBgPale;
  final Color greenBgMint;
  final Color orangeBgLight;
  final Color grayLight;
  final Color grayMedium;
  final Color grayDark;
  final Color greenBorderLight;
  final Color greenBorderSoft;
  final Color greenShadow;
  final Color blackTint4;
  final Color blackTint10;

  const GlossTheme({
    required this.green,
    required this.darkGreen,
    required this.bg,
    required this.card,
    required this.surface,
    required this.text,
    required this.hint,
    required this.greenText,
    required this.border,
    required this.disabled,
    required this.divider,
    required this.red,
    required this.orange,
    required this.star,
    required this.greenBgLight,
    required this.greenBgSoft,
    required this.greenBgPale,
    required this.greenBgMint,
    required this.orangeBgLight,
    required this.grayLight,
    required this.grayMedium,
    required this.grayDark,
    required this.greenBorderLight,
    required this.greenBorderSoft,
    required this.greenShadow,
    required this.blackTint4,
    required this.blackTint10,
  });

  static const light = GlossTheme(
    green: GlossColors.green,
    darkGreen: GlossColors.darkGreen,
    bg: GlossColors.bg,
    card: GlossColors.card,
    surface: GlossColors.surface,
    text: GlossColors.text,
    hint: GlossColors.hint,
    greenText: GlossColors.greenText,
    border: GlossColors.border,
    disabled: GlossColors.disabled,
    divider: GlossColors.divider,
    red: GlossColors.red,
    orange: GlossColors.orange,
    star: GlossColors.star,
    greenBgLight: GlossColors.greenBgLight,
    greenBgSoft: GlossColors.greenBgSoft,
    greenBgPale: GlossColors.greenBgPale,
    greenBgMint: GlossColors.greenBgMint,
    orangeBgLight: GlossColors.orangeBgLight,
    grayLight: GlossColors.grayLight,
    grayMedium: GlossColors.grayMedium,
    grayDark: GlossColors.grayDark,
    greenBorderLight: GlossColors.greenBorderLight,
    greenBorderSoft: GlossColors.greenBorderSoft,
    greenShadow: GlossColors.greenShadow,
    blackTint4: GlossColors.blackTint4,
    blackTint10: GlossColors.blackTint10,
  );

  @override
  GlossTheme copyWith({
    Color? green,
    Color? darkGreen,
    Color? bg,
    Color? card,
    Color? surface,
    Color? text,
    Color? hint,
    Color? greenText,
    Color? border,
    Color? disabled,
    Color? divider,
    Color? red,
    Color? orange,
    Color? star,
    Color? greenBgLight,
    Color? greenBgSoft,
    Color? greenBgPale,
    Color? greenBgMint,
    Color? orangeBgLight,
    Color? grayLight,
    Color? grayMedium,
    Color? grayDark,
    Color? greenBorderLight,
    Color? greenBorderSoft,
    Color? greenShadow,
    Color? blackTint4,
    Color? blackTint10,
  }) {
    return GlossTheme(
      green: green ?? this.green,
      darkGreen: darkGreen ?? this.darkGreen,
      bg: bg ?? this.bg,
      card: card ?? this.card,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      hint: hint ?? this.hint,
      greenText: greenText ?? this.greenText,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
      divider: divider ?? this.divider,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      star: star ?? this.star,
      greenBgLight: greenBgLight ?? this.greenBgLight,
      greenBgSoft: greenBgSoft ?? this.greenBgSoft,
      greenBgPale: greenBgPale ?? this.greenBgPale,
      greenBgMint: greenBgMint ?? this.greenBgMint,
      orangeBgLight: orangeBgLight ?? this.orangeBgLight,
      grayLight: grayLight ?? this.grayLight,
      grayMedium: grayMedium ?? this.grayMedium,
      grayDark: grayDark ?? this.grayDark,
      greenBorderLight: greenBorderLight ?? this.greenBorderLight,
      greenBorderSoft: greenBorderSoft ?? this.greenBorderSoft,
      greenShadow: greenShadow ?? this.greenShadow,
      blackTint4: blackTint4 ?? this.blackTint4,
      blackTint10: blackTint10 ?? this.blackTint10,
    );
  }

  @override
  GlossTheme lerp(ThemeExtension<GlossTheme>? other, double t) {
    if (other is! GlossTheme) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return GlossTheme(
      green: l(green, other.green),
      darkGreen: l(darkGreen, other.darkGreen),
      bg: l(bg, other.bg),
      card: l(card, other.card),
      surface: l(surface, other.surface),
      text: l(text, other.text),
      hint: l(hint, other.hint),
      greenText: l(greenText, other.greenText),
      border: l(border, other.border),
      disabled: l(disabled, other.disabled),
      divider: l(divider, other.divider),
      red: l(red, other.red),
      orange: l(orange, other.orange),
      star: l(star, other.star),
      greenBgLight: l(greenBgLight, other.greenBgLight),
      greenBgSoft: l(greenBgSoft, other.greenBgSoft),
      greenBgPale: l(greenBgPale, other.greenBgPale),
      greenBgMint: l(greenBgMint, other.greenBgMint),
      orangeBgLight: l(orangeBgLight, other.orangeBgLight),
      grayLight: l(grayLight, other.grayLight),
      grayMedium: l(grayMedium, other.grayMedium),
      grayDark: l(grayDark, other.grayDark),
      greenBorderLight: l(greenBorderLight, other.greenBorderLight),
      greenBorderSoft: l(greenBorderSoft, other.greenBorderSoft),
      greenShadow: l(greenShadow, other.greenShadow),
      blackTint4: l(blackTint4, other.blackTint4),
      blackTint10: l(blackTint10, other.blackTint10),
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GlossColors.green,
      brightness: Brightness.light,
    ),
    extensions: const [GlossTheme.light],
    scaffoldBackgroundColor: GlossColors.bg,
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelSmall: AppTypography.labelSmall,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: GlossColors.green,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: GlossColors.border),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
