import 'package:flutter/material.dart';
import 'colors.dart';
import 'color_tokens.dart';

/// Extension on ColorScheme to provide app-specific colors
extension AppColorScheme on ColorScheme {
  // Primary Colors
  Color get primaryBranding => AppColors.purpleBranding500;
  Color get primaryLight => AppColors.purpleLight500;
  Color get primaryDark => AppColors.purpleDark500;
  Color get primaryPremier => AppColors.purplePremier500;

  // Secondary Colors
  Color get secondaryBranding => AppColors.orangeBranding500;
  Color get secondaryPremier => AppColors.goldPremier500;

  // Semantic Colors
  Color get positive => AppColors.green500;
  Color get negative => AppColors.red500;
  Color get warning => AppColors.yellow500;

  // Accent Colors
  Color get accent1 => AppColors.blue500;
  Color get accent2 => AppColors.pink500;
  Color get accent3 => AppColors.teal500;

  // State Colors
  Color get stateBlack => AppColors.dimBlack500;
  Color get stateWhite => AppColors.dimWhite500;
}

/// Custom color scheme extension for semantic colors
class AppColorSchemeExtension extends ThemeExtension<AppColorSchemeExtension> {
  const AppColorSchemeExtension({
    required this.textMain,
    required this.textSub,
    required this.textPositive,
    required this.textNegative,
    required this.textWarning,
    required this.textTertiary,
    required this.textLink,
    required this.textPlaceholder,
    required this.textReverse,
    required this.textNeutral,
    required this.textPressed,
    required this.textDisable,
    required this.surfaceNegative,
    required this.surfaceMain,
    required this.surfacePositive,
    required this.surfaceNeutral,
    required this.surfaceWarning,
    required this.surfaceOverlay,
    required this.surfaceAccent,
    required this.surfaceGreyComponent,
    required this.surfaceNeutralComponent,
    required this.surfacePositiveComponent,
    required this.surfaceNegativeComponent,
    required this.surfacePressed,
    required this.surfaceDisable,
    required this.surfaceNeutralComponent2,
    required this.surfaceAccentComponent,
    required this.surfaceGreyComponent2,
    required this.surfaceSub,
    required this.borderActive,
    required this.borderDefault,
    required this.borderPositiveComponent,
    required this.borderNeutralComponent,
    required this.iconWarning,
    required this.iconNeutral,
    required this.iconNegative,
    required this.iconPositive,
    required this.iconAccent,
    required this.iconMain,
    required this.iconSub,
    required this.iconPlaceHolder,
    required this.iconTertiary,
    required this.iconReverse,
    required this.iconPressed,
    required this.iconDisable,
    required this.shadowSub,
    required this.shadowMain,
    required this.backgroundSub,
    required this.backgroundMain,
  });

  // Text Colors
  final Color textMain;
  final Color textSub;
  final Color textPositive;
  final Color textNegative;
  final Color textWarning;
  final Color textTertiary;
  final Color textLink;
  final Color textPlaceholder;
  final Color textReverse;
  final Color textNeutral;
  final Color textPressed;
  final Color textDisable;

  // Surface Colors
  final Color surfaceNegative;
  final Color surfaceMain;
  final Color surfacePositive;
  final Color surfaceNeutral;
  final Color surfaceWarning;
  final Color surfaceOverlay;
  final Color surfaceAccent;
  final Color surfaceGreyComponent;
  final Color surfaceNeutralComponent;
  final Color surfacePositiveComponent;
  final Color surfaceNegativeComponent;
  final Color surfacePressed;
  final Color surfaceDisable;
  final Color surfaceNeutralComponent2;
  final Color surfaceAccentComponent;
  final Color surfaceGreyComponent2;
  final Color surfaceSub;

  // Border Colors
  final Color borderActive;
  final Color borderDefault;
  final Color borderPositiveComponent;
  final Color borderNeutralComponent;

  // Icon Colors
  final Color iconWarning;
  final Color iconNeutral;
  final Color iconNegative;
  final Color iconPositive;
  final Color iconAccent;
  final Color iconMain;
  final Color iconSub;
  final Color iconPlaceHolder;
  final Color iconTertiary;
  final Color iconReverse;
  final Color iconPressed;
  final Color iconDisable;

  // Shadow Colors
  final Color shadowSub;
  final Color shadowMain;

  // Background Colors
  final Color backgroundSub;
  final Color backgroundMain;

  @override
  ThemeExtension<AppColorSchemeExtension> copyWith({
    Color? textMain,
    Color? textSub,
    Color? textPositive,
    Color? textNegative,
    Color? textWarning,
    Color? textTertiary,
    Color? textLink,
    Color? textPlaceholder,
    Color? textReverse,
    Color? textNeutral,
    Color? textPressed,
    Color? textDisable,
    Color? surfaceNegative,
    Color? surfaceMain,
    Color? surfacePositive,
    Color? surfaceNeutral,
    Color? surfaceWarning,
    Color? surfaceOverlay,
    Color? surfaceAccent,
    Color? surfaceGreyComponent,
    Color? surfaceNeutralComponent,
    Color? surfacePositiveComponent,
    Color? surfaceNegativeComponent,
    Color? surfacePressed,
    Color? surfaceDisable,
    Color? surfaceNeutralComponent2,
    Color? surfaceAccentComponent,
    Color? surfaceGreyComponent2,
    Color? surfaceSub,
    Color? borderActive,
    Color? borderDefault,
    Color? borderPositiveComponent,
    Color? borderNeutralComponent,
    Color? iconWarning,
    Color? iconNeutral,
    Color? iconNegative,
    Color? iconPositive,
    Color? iconAccent,
    Color? iconMain,
    Color? iconSub,
    Color? iconPlaceHolder,
    Color? iconTertiary,
    Color? iconReverse,
    Color? iconPressed,
    Color? iconDisable,
    Color? shadowSub,
    Color? shadowMain,
    Color? backgroundSub,
    Color? backgroundMain,
  }) {
    return AppColorSchemeExtension(
      textMain: textMain ?? this.textMain,
      textSub: textSub ?? this.textSub,
      textPositive: textPositive ?? this.textPositive,
      textNegative: textNegative ?? this.textNegative,
      textWarning: textWarning ?? this.textWarning,
      textTertiary: textTertiary ?? this.textTertiary,
      textLink: textLink ?? this.textLink,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      textReverse: textReverse ?? this.textReverse,
      textNeutral: textNeutral ?? this.textNeutral,
      textPressed: textPressed ?? this.textPressed,
      textDisable: textDisable ?? this.textDisable,
      surfaceNegative: surfaceNegative ?? this.surfaceNegative,
      surfaceMain: surfaceMain ?? this.surfaceMain,
      surfacePositive: surfacePositive ?? this.surfacePositive,
      surfaceNeutral: surfaceNeutral ?? this.surfaceNeutral,
      surfaceWarning: surfaceWarning ?? this.surfaceWarning,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      surfaceAccent: surfaceAccent ?? this.surfaceAccent,
      surfaceGreyComponent: surfaceGreyComponent ?? this.surfaceGreyComponent,
      surfaceNeutralComponent:
          surfaceNeutralComponent ?? this.surfaceNeutralComponent,
      surfacePositiveComponent:
          surfacePositiveComponent ?? this.surfacePositiveComponent,
      surfaceNegativeComponent:
          surfaceNegativeComponent ?? this.surfaceNegativeComponent,
      surfacePressed: surfacePressed ?? this.surfacePressed,
      surfaceDisable: surfaceDisable ?? this.surfaceDisable,
      surfaceNeutralComponent2:
          surfaceNeutralComponent2 ?? this.surfaceNeutralComponent2,
      surfaceAccentComponent:
          surfaceAccentComponent ?? this.surfaceAccentComponent,
      surfaceGreyComponent2:
          surfaceGreyComponent2 ?? this.surfaceGreyComponent2,
      surfaceSub: surfaceSub ?? this.surfaceSub,
      borderActive: borderActive ?? this.borderActive,
      borderDefault: borderDefault ?? this.borderDefault,
      borderPositiveComponent:
          borderPositiveComponent ?? this.borderPositiveComponent,
      borderNeutralComponent:
          borderNeutralComponent ?? this.borderNeutralComponent,
      iconWarning: iconWarning ?? this.iconWarning,
      iconNeutral: iconNeutral ?? this.iconNeutral,
      iconNegative: iconNegative ?? this.iconNegative,
      iconPositive: iconPositive ?? this.iconPositive,
      iconAccent: iconAccent ?? this.iconAccent,
      iconMain: iconMain ?? this.iconMain,
      iconSub: iconSub ?? this.iconSub,
      iconPlaceHolder: iconPlaceHolder ?? this.iconPlaceHolder,
      iconTertiary: iconTertiary ?? this.iconTertiary,
      iconReverse: iconReverse ?? this.iconReverse,
      iconPressed: iconPressed ?? this.iconPressed,
      iconDisable: iconDisable ?? this.iconDisable,
      shadowSub: shadowSub ?? this.shadowSub,
      shadowMain: shadowMain ?? this.shadowMain,
      backgroundSub: backgroundSub ?? this.backgroundSub,
      backgroundMain: backgroundMain ?? this.backgroundMain,
    );
  }

  @override
  ThemeExtension<AppColorSchemeExtension> lerp(
    covariant ThemeExtension<AppColorSchemeExtension>? other,
    double t,
  ) {
    if (other is! AppColorSchemeExtension) {
      return this;
    }

    return AppColorSchemeExtension(
      textMain: Color.lerp(textMain, other.textMain, t)!,
      textSub: Color.lerp(textSub, other.textSub, t)!,
      textPositive: Color.lerp(textPositive, other.textPositive, t)!,
      textNegative: Color.lerp(textNegative, other.textNegative, t)!,
      textWarning: Color.lerp(textWarning, other.textWarning, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      textReverse: Color.lerp(textReverse, other.textReverse, t)!,
      textNeutral: Color.lerp(textNeutral, other.textNeutral, t)!,
      textPressed: Color.lerp(textPressed, other.textPressed, t)!,
      textDisable: Color.lerp(textDisable, other.textDisable, t)!,
      surfaceNegative: Color.lerp(surfaceNegative, other.surfaceNegative, t)!,
      surfaceMain: Color.lerp(surfaceMain, other.surfaceMain, t)!,
      surfacePositive: Color.lerp(surfacePositive, other.surfacePositive, t)!,
      surfaceNeutral: Color.lerp(surfaceNeutral, other.surfaceNeutral, t)!,
      surfaceWarning: Color.lerp(surfaceWarning, other.surfaceWarning, t)!,
      surfaceOverlay: Color.lerp(surfaceOverlay, other.surfaceOverlay, t)!,
      surfaceAccent: Color.lerp(surfaceAccent, other.surfaceAccent, t)!,
      surfaceGreyComponent:
          Color.lerp(surfaceGreyComponent, other.surfaceGreyComponent, t)!,
      surfaceNeutralComponent: Color.lerp(
          surfaceNeutralComponent, other.surfaceNeutralComponent, t)!,
      surfacePositiveComponent: Color.lerp(
          surfacePositiveComponent, other.surfacePositiveComponent, t)!,
      surfaceNegativeComponent: Color.lerp(
          surfaceNegativeComponent, other.surfaceNegativeComponent, t)!,
      surfacePressed: Color.lerp(surfacePressed, other.surfacePressed, t)!,
      surfaceDisable: Color.lerp(surfaceDisable, other.surfaceDisable, t)!,
      surfaceNeutralComponent2: Color.lerp(
          surfaceNeutralComponent2, other.surfaceNeutralComponent2, t)!,
      surfaceAccentComponent:
          Color.lerp(surfaceAccentComponent, other.surfaceAccentComponent, t)!,
      surfaceGreyComponent2:
          Color.lerp(surfaceGreyComponent2, other.surfaceGreyComponent2, t)!,
      surfaceSub: Color.lerp(surfaceSub, other.surfaceSub, t)!,
      borderActive: Color.lerp(borderActive, other.borderActive, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderPositiveComponent: Color.lerp(
          borderPositiveComponent, other.borderPositiveComponent, t)!,
      borderNeutralComponent:
          Color.lerp(borderNeutralComponent, other.borderNeutralComponent, t)!,
      iconWarning: Color.lerp(iconWarning, other.iconWarning, t)!,
      iconNeutral: Color.lerp(iconNeutral, other.iconNeutral, t)!,
      iconNegative: Color.lerp(iconNegative, other.iconNegative, t)!,
      iconPositive: Color.lerp(iconPositive, other.iconPositive, t)!,
      iconAccent: Color.lerp(iconAccent, other.iconAccent, t)!,
      iconMain: Color.lerp(iconMain, other.iconMain, t)!,
      iconSub: Color.lerp(iconSub, other.iconSub, t)!,
      iconPlaceHolder: Color.lerp(iconPlaceHolder, other.iconPlaceHolder, t)!,
      iconTertiary: Color.lerp(iconTertiary, other.iconTertiary, t)!,
      iconReverse: Color.lerp(iconReverse, other.iconReverse, t)!,
      iconPressed: Color.lerp(iconPressed, other.iconPressed, t)!,
      iconDisable: Color.lerp(iconDisable, other.iconDisable, t)!,
      shadowSub: Color.lerp(shadowSub, other.shadowSub, t)!,
      shadowMain: Color.lerp(shadowMain, other.shadowMain, t)!,
      backgroundSub: Color.lerp(backgroundSub, other.backgroundSub, t)!,
      backgroundMain: Color.lerp(backgroundMain, other.backgroundMain, t)!,
    );
  }

  /// Light theme colors
  static final light = AppColorSchemeExtension(
    // Text Colors
    textMain: ColorTokens.primaryLight[700]!,
    textSub: ColorTokens.primaryLight[600]!,
    textPositive: ColorTokens.positive[500]!,
    textNegative: ColorTokens.negative[500]!,
    textWarning: ColorTokens.warning[500]!,
    textTertiary: ColorTokens.primaryLight[400]!,
    textLink: ColorTokens.secondaryBranding[500]!,
    textPlaceholder: ColorTokens.primaryLight[500]!,
    textReverse: ColorTokens.primaryLight[100]!,
    textNeutral: ColorTokens.neutral[600]!,
    textPressed: ColorTokens.stateBlack[100]!,
    textDisable: ColorTokens.stateWhite[600]!,

    // Surface Colors
    surfaceNegative: ColorTokens.negative[100]!,
    surfaceMain: ColorTokens.primaryLight[100]!,
    surfacePositive: ColorTokens.positive[100]!,
    surfaceNeutral: ColorTokens.neutral[50]!,
    surfaceWarning: ColorTokens.warning[100]!,
    surfaceOverlay: ColorTokens.overlayDim[400]!,
    surfaceAccent: ColorTokens.secondaryBranding[50]!,
    surfaceGreyComponent: ColorTokens.primaryLight[500]!,
    surfaceNeutralComponent: ColorTokens.neutral[600]!,
    surfacePositiveComponent: ColorTokens.positive[500]!,
    surfaceNegativeComponent: ColorTokens.negative[500]!,
    surfacePressed: ColorTokens.stateBlack[100]!,
    surfaceDisable: ColorTokens.stateWhite[600]!,
    surfaceNeutralComponent2: ColorTokens.neutral[100]!,
    surfaceAccentComponent: ColorTokens.secondaryBranding[500]!,
    surfaceGreyComponent2: ColorTokens.primaryLight[600]!,
    surfaceSub: ColorTokens.primaryLight[200]!,

    // Border Colors
    borderActive: ColorTokens.secondaryBranding[500]!,
    borderDefault: ColorTokens.primaryLight[300]!,
    borderPositiveComponent: ColorTokens.positive[500]!,
    borderNeutralComponent: ColorTokens.neutral[600]!,

    // Icon colors
    iconWarning: ColorTokens.warning[500]!,
    iconNeutral: ColorTokens.neutral[600]!,
    iconNegative: ColorTokens.negative[500]!,
    iconPositive: ColorTokens.positive[500]!,
    iconAccent: ColorTokens.secondaryBranding[500]!,
    iconMain: ColorTokens.primaryLight[700]!,
    iconSub: ColorTokens.primaryLight[600]!,
    iconPlaceHolder: ColorTokens.primaryLight[500]!,
    iconTertiary: ColorTokens.primaryLight[400]!,
    iconReverse: ColorTokens.primaryLight[100]!,
    iconPressed: ColorTokens.stateBlack[100]!,
    iconDisable: ColorTokens.stateWhite[600]!,

    // Shadow colors
    shadowMain: ColorTokens.effect[50]!,
    shadowSub: ColorTokens.effect[200]!,

    // Background colors
    backgroundMain: ColorTokens.primaryLight[100]!,
    backgroundSub: ColorTokens.primaryLight[200]!,
  );

  /// Dark theme colors
  static final dark = AppColorSchemeExtension(
    // Text Colors
    textMain: ColorTokens.primaryDark[100]!,
    textSub: ColorTokens.primaryDark[200]!,
    textPositive: ColorTokens.positive[500]!,
    textNegative: ColorTokens.negative[500]!,
    textWarning: ColorTokens.warning[500]!,
    textTertiary: ColorTokens.primaryDark[500]!,
    textLink: ColorTokens.secondaryBranding[500]!,
    textPlaceholder: ColorTokens.primaryDark[400]!,
    textReverse: ColorTokens.primaryLight[100]!,
    textNeutral: ColorTokens.neutral[400]!,
    textPressed: ColorTokens.stateBlack[200]!,
    textDisable: ColorTokens.stateBlack[600]!,

    // Surface Colors
    surfaceNegative: ColorTokens.negative[900]!,
    surfaceMain: ColorTokens.primaryDark[600]!,
    surfacePositive: ColorTokens.positive[900]!,
    surfaceNeutral: ColorTokens.neutral[900]!,
    surfaceWarning: ColorTokens.warning[900]!,
    surfaceOverlay: ColorTokens.overlayDim[800]!,
    surfaceAccent: ColorTokens.secondaryBranding[50]!,
    surfaceGreyComponent: ColorTokens.primaryDark[400]!,
    surfaceNeutralComponent: ColorTokens.neutral[600]!,
    surfacePositiveComponent: ColorTokens.positive[500]!,
    surfaceNegativeComponent: ColorTokens.negative[500]!,
    surfacePressed: ColorTokens.stateBlack[200]!,
    surfaceDisable: ColorTokens.stateBlack[600]!,
    surfaceNeutralComponent2: ColorTokens.neutral[800]!,
    surfaceAccentComponent: ColorTokens.secondaryBranding[500]!,
    surfaceGreyComponent2: ColorTokens.primaryLight[600]!,
    surfaceSub: ColorTokens.primaryDark[700]!,

    // Border Colors
    borderActive: ColorTokens.secondaryBranding[500]!,
    borderDefault: ColorTokens.primaryDark[300]!,
    borderPositiveComponent: ColorTokens.positive[500]!,
    borderNeutralComponent: ColorTokens.neutral[600]!,

    // Icon colors
    iconWarning: ColorTokens.warning[500]!,
    iconNeutral: ColorTokens.neutral[400]!,
    iconNegative: ColorTokens.negative[500]!,
    iconPositive: ColorTokens.positive[500]!,
    iconAccent: ColorTokens.secondaryBranding[500]!,
    iconMain: ColorTokens.primaryDark[100]!,
    iconSub: ColorTokens.primaryDark[200]!,
    iconPlaceHolder: ColorTokens.primaryDark[400]!,
    iconTertiary: ColorTokens.primaryDark[500]!,
    iconReverse: ColorTokens.primaryLight[100]!,
    iconPressed: ColorTokens.stateBlack[200]!,
    iconDisable: ColorTokens.stateBlack[600]!,

    // Shadow colors
    shadowMain: ColorTokens.effect[50]!,
    shadowSub: ColorTokens.effect[600]!,

    // Background colors
    backgroundMain: ColorTokens.primaryDark[600]!,
    backgroundSub: ColorTokens.primaryDark[700]!,
  );

  /// Premier theme colors
  static final premier = AppColorSchemeExtension(
    // Text Colors
    textMain: ColorTokens.primaryPremier[800]!,
    textSub: ColorTokens.primaryPremier[600]!,
    textPositive: ColorTokens.positive[500]!,
    textNegative: ColorTokens.negative[500]!,
    textWarning: ColorTokens.warning[500]!,
    textTertiary: ColorTokens.primaryPremier[500]!,
    textLink: ColorTokens.secondaryPremier[400]!,
    textPlaceholder: ColorTokens.primaryPremier[400]!,
    textReverse: ColorTokens.primaryLight[100]!,
    textNeutral: ColorTokens.neutral[800]!,
    textPressed: ColorTokens.stateBlack[100]!,
    textDisable: ColorTokens.stateWhite[600]!,

    // Surface Colors
    surfaceNegative: ColorTokens.negative[100]!,
    surfaceMain: ColorTokens.primaryPremier[100]!,
    surfacePositive: ColorTokens.positive[100]!,
    surfaceNeutral: ColorTokens.neutral[50]!,
    surfaceWarning: ColorTokens.warning[100]!,
    surfaceOverlay: ColorTokens.overlayDim[400]!,
    surfaceAccent: ColorTokens.secondaryPremier[50]!,
    surfaceGreyComponent: ColorTokens.primaryPremier[400]!,
    surfaceNeutralComponent: ColorTokens.neutral[600]!,
    surfacePositiveComponent: ColorTokens.positive[500]!,
    surfaceNegativeComponent: ColorTokens.negative[500]!,
    surfacePressed: ColorTokens.stateBlack[100]!,
    surfaceDisable: ColorTokens.stateWhite[600]!,
    surfaceNeutralComponent2: ColorTokens.neutral[100]!,
    surfaceAccentComponent: ColorTokens.secondaryPremier[400]!,
    surfaceGreyComponent2: ColorTokens.primaryLight[600]!,
    surfaceSub: ColorTokens.primaryPremier[200]!,

    // Border Colors
    borderActive: ColorTokens.secondaryPremier[400]!,
    borderDefault: ColorTokens.primaryLight[300]!,
    borderPositiveComponent: ColorTokens.positive[500]!,
    borderNeutralComponent: ColorTokens.neutral[600]!,

    // Icon colors
    iconWarning: ColorTokens.warning[500]!,
    iconNeutral: ColorTokens.neutral[800]!,
    iconNegative: ColorTokens.negative[500]!,
    iconPositive: ColorTokens.positive[500]!,
    iconAccent: ColorTokens.secondaryPremier[400]!,
    iconMain: ColorTokens.primaryPremier[800]!,
    iconSub: ColorTokens.primaryPremier[600]!,
    iconPlaceHolder: ColorTokens.primaryPremier[400]!,
    iconTertiary: ColorTokens.primaryPremier[500]!,
    iconReverse: ColorTokens.primaryLight[100]!,
    iconPressed: ColorTokens.stateBlack[100]!,
    iconDisable: ColorTokens.stateWhite[600]!,

    // Shadow colors
    shadowMain: ColorTokens.effect[50]!,
    shadowSub: ColorTokens.effect[200]!,

    // Background colors
    backgroundMain: ColorTokens.primaryPremier[100]!,
    backgroundSub: ColorTokens.primaryPremier[200]!,
  );
}
