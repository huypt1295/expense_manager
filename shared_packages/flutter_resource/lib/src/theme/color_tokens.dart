import 'package:flutter/material.dart';
import 'colors.dart';

/// Color tokens for the application
class ColorTokens {
  ColorTokens._();

  static const primaryBranding = MaterialColor(
    0xFF9758d0, // purple-branding.500
    <int, Color>{
      50: AppColors.purpleBranding50,
      100: AppColors.purpleBranding100,
      200: AppColors.purpleBranding200,
      300: AppColors.purpleBranding300,
      400: AppColors.purpleBranding400,
      500: AppColors.purpleBranding500,
      600: AppColors.purpleBranding600,
      700: AppColors.purpleBranding700,
      800: AppColors.purpleBranding800,
      900: AppColors.purpleBranding900,
      950: AppColors.purpleBranding950,
    },
  );

  static const primaryLight = MaterialColor(
    0xFFD1D0D9, // purple-light.500
    <int, Color>{
      100: AppColors.purpleLight100,
      200: AppColors.purpleLight200,
      300: AppColors.purpleLight300,
      400: AppColors.purpleLight400,
      500: AppColors.purpleLight500,
      600: AppColors.purpleLight600,
      700: AppColors.purpleLight700,
    },
  );

  static const primaryDark = MaterialColor(
    0xFF3c2e49, // purple-dark.500
    <int, Color>{
      100: AppColors.purpleDark100,
      200: AppColors.purpleDark200,
      300: AppColors.purpleDark300,
      400: AppColors.purpleDark400,
      500: AppColors.purpleDark500,
      600: AppColors.purpleDark600,
      700: AppColors.purpleDark700,
    },
  );

  static const primaryPremier = MaterialColor(
    0xFFcccccc, // purple-premier.500
    <int, Color>{
      100: AppColors.purplePremier100,
      200: AppColors.purplePremier200,
      300: AppColors.purplePremier300,
      400: AppColors.purplePremier400,
      500: AppColors.purplePremier500,
      600: AppColors.purplePremier600,
      700: AppColors.purplePremier700,
      800: AppColors.purplePremier800,
    },
  );

  static const secondaryBranding = MaterialColor(
    0xFFFF9800, // orange-branding.500
    <int, Color>{
      50: AppColors.orangeBranding50,
      100: AppColors.orangeBranding100,
      200: AppColors.orangeBranding200,
      300: AppColors.orangeBranding300,
      400: AppColors.orangeBranding400,
      500: AppColors.orangeBranding500,
      600: AppColors.orangeBranding600,
      700: AppColors.orangeBranding700,
      800: AppColors.orangeBranding800,
      900: AppColors.orangeBranding900,
      950: AppColors.orangeBranding950,
    },
  );

  static const secondaryPremier = MaterialColor(
    0xFFB4875B, // gold-premier.500
    <int, Color>{
      50: AppColors.goldPremier50,
      100: AppColors.goldPremier100,
      200: AppColors.goldPremier200,
      300: AppColors.goldPremier300,
      400: AppColors.goldPremier400,
      500: AppColors.goldPremier500,
      600: AppColors.goldPremier600,
      700: AppColors.goldPremier700,
      800: AppColors.goldPremier800,
      900: AppColors.goldPremier900,
      950: AppColors.goldPremier950,
    },
  );

  static const positive = MaterialColor(
    0xFF16A163, // green.500
    <int, Color>{
      50: AppColors.green50,
      100: AppColors.green100,
      200: AppColors.green200,
      300: AppColors.green300,
      400: AppColors.green400,
      500: AppColors.green500,
      600: AppColors.green600,
      700: AppColors.green700,
      800: AppColors.green800,
      900: AppColors.green900,
      950: AppColors.green950,
    },
  );

  static const negative = MaterialColor(
    0xFFFA5343, // red.500
    <int, Color>{
      50: AppColors.red50,
      100: AppColors.red100,
      200: AppColors.red200,
      300: AppColors.red300,
      400: AppColors.red400,
      500: AppColors.red500,
      600: AppColors.red600,
      700: AppColors.red700,
      800: AppColors.red800,
      900: AppColors.red900,
      950: AppColors.red950,
    },
  );

  static const warning = MaterialColor(
    0xFFCF9F02, // yellow.500
    <int, Color>{
      50: AppColors.yellow50,
      100: AppColors.yellow100,
      200: AppColors.yellow200,
      300: AppColors.yellow300,
      400: AppColors.yellow400,
      500: AppColors.yellow500,
      600: AppColors.yellow600,
      700: AppColors.yellow700,
      800: AppColors.yellow800,
      900: AppColors.yellow900,
      950: AppColors.yellow950,
    },
  );

    static const neutral = MaterialColor(
    0xFF9758d0, // purple-branding.500
    <int, Color>{
      50: AppColors.purpleBranding50,
      100: AppColors.purpleBranding100,
      200: AppColors.purpleBranding200,
      300: AppColors.purpleBranding300,
      400: AppColors.purpleBranding400,
      500: AppColors.purpleBranding500,
      600: AppColors.purpleBranding600,
      700: AppColors.purpleBranding700,
      800: AppColors.purpleBranding800,
      900: AppColors.purpleBranding900,
      950: AppColors.purpleBranding950,
    },
  );

  static const accent1 = MaterialColor(
    0xFF3d8df5, // blue.500
    <int, Color>{
      50: AppColors.blue50,
      100: AppColors.blue100,
      200: AppColors.blue200,
      300: AppColors.blue300,
      400: AppColors.blue400,
      500: AppColors.blue500,
      600: AppColors.blue600,
      700: AppColors.blue700,
      800: AppColors.blue800,
      900: AppColors.blue900,
      950: AppColors.blue950,
    },
  );

  static const accent2 = MaterialColor(
    0xFFed4cb7, // pink.500
    <int, Color>{
      50: AppColors.pink50,
      100: AppColors.pink100,
      200: AppColors.pink200,
      300: AppColors.pink300,
      400: AppColors.pink400,
      500: AppColors.pink500,
      600: AppColors.pink600,
      700: AppColors.pink700,
      800: AppColors.pink800,
      900: AppColors.pink900,
      950: AppColors.pink950,
    },
  );

  static const accent3 = MaterialColor(
    0xFF279c9c, // teal.500
    <int, Color>{
      50: AppColors.teal50,
      100: AppColors.teal100,
      200: AppColors.teal200,
      300: AppColors.teal300,
      400: AppColors.teal400,
      500: AppColors.teal500,
      600: AppColors.teal600,
      700: AppColors.teal700,
      800: AppColors.teal800,
      900: AppColors.teal900,
      950: AppColors.teal950,
    },
  );

  static const effect = MaterialColor(
    0xFF000000,
    <int, Color>{
      50: AppColors.dimBlack50,
      200: AppColors.dimBlack200,
      600: AppColors.dimBlack600,
    },
  );

  static const overlayDim = MaterialColor(
    0xFF000000,
    <int, Color>{
      400: AppColors.dimBlack400,
      800: AppColors.dimBlack800,
    },
  );

  static const stateBlack = MaterialColor(
    0xFF000000,
    <int, Color>{
      100: AppColors.dimBlack100,
      200: AppColors.dimBlack200,
      600: AppColors.dimBlack600,
    },
  );

  static const stateWhite = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      600: AppColors.dimWhite600,
    },
  );
}