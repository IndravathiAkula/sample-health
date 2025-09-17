import 'package:flutter/material.dart';

/// A class that contains all theme configurations for the healthcare application.
/// Implements Clinical Minimalism design philosophy with beautiful and catchy color scheme.
/// Uses Bogart Alt Regular as primary font, MD SYSTEM NARROW as secondary, and Georgia as fallback.
class AppTheme {
  AppTheme._();

  // Font Configuration - Healthcare application font hierarchy
  static const String primaryFontFamily = 'Bogart Alt Regular';
  static const String secondaryFontFamily = 'MD SYSTEM NARROW';
  static const String fallbackFontFamily = 'Georgia';

  // Font fallback list - will try in order until one is available
  static const List<String> fontFamilyFallbacks = [
    primaryFontFamily,
    secondaryFontFamily,
    fallbackFontFamily,
    'serif', // System serif fallback
  ];

  // PRIMARY COLORS
  static const Color ovalGreen = Color(0xFF013935); // Most important color
  static const Color pacifierGray = Color(0xFF414242);
  static const Color bambiBeige = Color(0xFFFFFFFF); // changed

  // SECONDARY COLORS
  static const Color snuggleBlue = Color(0xFFB6D9E9);
  static const Color blankieGreen = Color(0xFFCCE0B9);
  static const Color swaddlePink = Color(0xFFEFCEBD);

  // Color palette for text based on background type
  static const Color bunnyIvory =
      Color(0xFFFAF5E4); // Bunny Ivory for dark backgrounds

  // Enhanced contrast colors for better visibility
  static const Color ovalGreenDarker =
      Color(0xFF001A17); // Darker oval green for better contrast
  static const Color ovalGreenLighter =
      Color(0xFFEFCEBD); // Lighter oval green for dark backgrounds// chnaged
  static const Color pacifierGrayDarker =
      Color(0xFF2D2D2D); // Darker gray for text
  static const Color pacifierGrayLighter =
      Color(0xFF6B6B6B); // Lighter gray for secondary text

  // Beautiful and catchy color palette - Updated with enhanced visibility
  static const Color primaryLight = ovalGreen; // Main oval green as primary
  static const Color primaryVariantLight =
      ovalGreenDarker; // Much darker variant for better contrast
  static const Color secondaryLight = snuggleBlue; // Secondary blue
  static const Color secondaryVariantLight =
      Color(0xFF8AC1D9); // Lighter variant of snuggle blue
  static const Color accentLight = blankieGreen; // Accent green
  static const Color warningLight = Color(0xFFF4A261); // Warm amber
  static const Color errorLight = Color(0xFFE76F51); // Controlled coral-red
  static const Color backgroundLight = bambiBeige; // Bambi beige background
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white
  static const Color textPrimaryLight =
      ovalGreen; // Oval green for light backgrounds with high contrast
  static const Color textSecondaryLight =
      pacifierGrayDarker; // Darker gray for better readability
  static final Color dividerLight =
      pacifierGray.withAlpha(102); // More visible gray

  // Dark theme variants maintaining beauty and catchiness with enhanced visibility
  static const Color primaryDark = ovalGreen; // Keep oval green for buttons
  static const Color primaryVariantDark =
      ovalGreenLighter; // Lighter variant for dark mode
  static const Color secondaryDark = snuggleBlue; // Keep snuggle blue
  static const Color secondaryVariantDark = Color(0xFF8AC1D9); // Lighter blue
  static const Color accentDark = blankieGreen; // Keep accent green
  static const Color warningDark = Color(0xFFF6B373); // Lighter amber
  static const Color errorDark = Color(0xFFEA8A73); // Lighter coral-red
  static const Color backgroundDark = Color(0xFF1A1A1A); // Deep dark background
  static const Color surfaceDark = Color(0xFF2D2D2D); // Dark surface
  static const Color textPrimaryDark =
      bunnyIvory; // Bunny ivory for dark backgrounds
  static const Color textSecondaryDark =
      Color(0xFFFAF5E4CC); // Enhanced contrast bunny ivory (204 alpha)
  static final Color dividerDark =
      pacifierGray.withAlpha(153); // More visible dark divider

  // Card and dialog colors for beautiful theme with enhanced contrast
  static const Color cardLight = Color(0xFFFFFFFF);
  static final Color cardDark = pacifierGrayDarker.withAlpha(230);
  static const Color dialogLight = Color(0xFFFFFFFF);
  static final Color dialogDark = pacifierGrayDarker.withAlpha(245);

  // Shadow colors with beautiful appropriate opacity
  static const Color shadowLight =
      Color(0x1A000000); // Increased opacity for better visibility
  static const Color shadowDark =
      Color(0x26FFFFFF); // Increased opacity for dark mode

  /// Helper method to create TextStyle with font hierarchy and background-aware text color
  static TextStyle _createTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontFamilyFallback:
          fontFamilyFallbacks.sublist(1), // Skip primary as it's already set
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Enhanced helper method to get text color based on background with improved contrast
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if background is dark
    double luminance = backgroundColor.computeLuminance();

    // Enhanced contrast calculation for better visibility
    if (luminance < 0.3) {
      // Very dark backgrounds - use Bunny Ivory
      return bunnyIvory;
    } else if (luminance < 0.6) {
      // Medium backgrounds - use darker Oval Green for better contrast
      return ovalGreenDarker;
    } else {
      // Light backgrounds - use standard Oval Green
      return ovalGreen;
    }
  }

  /// Enhanced helper method to get icon color with better visibility
  static Color getIconColorForBackground(Color backgroundColor,
      {bool isSelected = false}) {
    double luminance = backgroundColor.computeLuminance();

    if (isSelected) {
      // Selected icons should always be highly visible
      return luminance < 0.5 ? bunnyIvory : ovalGreen;
    } else {
      // Unselected icons with good contrast
      if (luminance < 0.3) {
        return bunnyIvory.withAlpha(179); // 70% opacity on dark
      } else if (luminance < 0.6) {
        return pacifierGrayDarker.withAlpha(179); // 70% opacity on medium
      } else {
        return pacifierGray.withAlpha(153); // 60% opacity on light
      }
    }
  }

  /// Light theme optimized for enhanced visibility and contrast
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: primaryFontFamily,
    fontFamilyFallback: fontFamilyFallbacks,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: getTextColorForBackground(primaryLight),
      primaryContainer: primaryVariantLight,
      onPrimaryContainer: bunnyIvory, // High contrast for dark container
      secondary: secondaryLight,
      onSecondary: getTextColorForBackground(secondaryLight),
      secondaryContainer: secondaryVariantLight,
      onSecondaryContainer: getTextColorForBackground(secondaryVariantLight),
      tertiary: accentLight,
      onTertiary: getTextColorForBackground(accentLight),
      tertiaryContainer: accentLight.withAlpha(51),
      onTertiaryContainer: textPrimaryLight,
      error: errorLight,
      onError: getTextColorForBackground(errorLight),
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: dividerLight,
      outlineVariant: dividerLight.withAlpha(153),
      shadow: shadowLight,
      scrim: Colors.black54,
      inverseSurface: surfaceDark,
      onInverseSurface: textPrimaryDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    dividerColor: dividerLight,

    // AppBar theme with enhanced visibility
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      elevation: 2.0, // Slightly more elevation for better separation
      shadowColor: shadowLight,
      titleTextStyle: _createTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimaryLight, size: 24),
    ),

    // Card theme with enhanced visibility
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 3.0, // Increased elevation for better visibility
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
            color: dividerLight.withAlpha(77),
            width: 0.5), // Subtle border for definition
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation with enhanced contrast
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: ovalGreen,
      unselectedItemColor: textSecondaryLight,
      elevation: 12.0, // Increased elevation for better separation
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: _createTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: ovalGreen,
      ),
      unselectedLabelStyle: _createTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryLight,
      ),
    ),

    // FAB theme with enhanced visibility
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ovalGreen,
      foregroundColor: getTextColorForBackground(ovalGreen),
      elevation: 6.0, // Increased elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes with enhanced visibility
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: getTextColorForBackground(ovalGreen),
        backgroundColor: ovalGreen, // Oval Green for buttons
        elevation: 3.0, // Increased elevation
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: _createTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: getTextColorForBackground(ovalGreen),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ovalGreen, // Oval Green for buttons
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(
            color: ovalGreen, width: 2.0), // Thicker border for visibility
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: _createTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ovalGreen,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ovalGreen, // Oval Green for buttons
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: _createTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600, // Increased weight for better visibility
          color: ovalGreen,
        ),
      ),
    ),

    // Typography theme with enhanced contrast
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration with enhanced visibility
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: dividerLight, width: 1.5), // Thicker border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerLight, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: ovalGreen, width: 2.5), // Thicker focus border
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorLight, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorLight, width: 2.5),
      ),
      labelStyle: _createTextStyle(
        color: textSecondaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w500, // Increased weight
      ),
      hintStyle: _createTextStyle(
        color: textSecondaryLight.withAlpha(153), // Better contrast
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: _createTextStyle(
        color: errorLight,
        fontSize: 12,
        fontWeight: FontWeight.w500, // Increased weight
      ),
    ),

    // Switch theme with enhanced visibility
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen; // Oval Green for switches
        }
        return pacifierGray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen.withAlpha(102); // Better opacity
        }
        return pacifierGray.withAlpha(102);
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen.withAlpha(51);
        }
        return pacifierGray.withAlpha(51);
      }),
    ),

    // Checkbox theme with enhanced visibility
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen; // Oval Green for checkboxes
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(getTextColorForBackground(ovalGreen)),
      side: BorderSide(color: pacifierGray, width: 2.0), // Better border
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio theme with enhanced visibility
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen; // Oval Green for radio buttons
        }
        return textSecondaryLight;
      }),
    ),

    // Progress indicators with enhanced visibility
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ovalGreen, // Oval Green for progress
      linearTrackColor: ovalGreen.withAlpha(77), // Better track visibility
      circularTrackColor: ovalGreen.withAlpha(77),
    ),

    // Slider theme with enhanced visibility
    sliderTheme: SliderThemeData(
      activeTrackColor: ovalGreen, // Oval Green for sliders
      thumbColor: ovalGreen,
      overlayColor: ovalGreen.withAlpha(77), // Better overlay
      inactiveTrackColor: ovalGreen.withAlpha(102), // Better inactive track
      valueIndicatorColor: ovalGreen,
      valueIndicatorTextStyle: _createTextStyle(
        color: getTextColorForBackground(ovalGreen),
        fontSize: 14,
        fontWeight: FontWeight.w600, // Increased weight
        letterSpacing: 0.5,
      ),
    ),

    // Tab bar theme with enhanced visibility
    tabBarTheme: TabBarThemeData(
      labelColor: ovalGreen, // Oval Green for tabs
      unselectedLabelColor: textSecondaryLight,
      indicatorColor: ovalGreen,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ovalGreen,
      ),
      unselectedLabelStyle: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500, // Increased weight
        color: textSecondaryLight,
      ),
    ),

    // Tooltip theme with enhanced visibility
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: pacifierGrayDarker,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _createTextStyle(
        color: bunnyIvory, // Dark tooltip background uses Bunny Ivory text
        fontSize: 14,
        fontWeight: FontWeight.w500, // Increased weight
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar theme with enhanced visibility
    snackBarTheme: SnackBarThemeData(
      backgroundColor: pacifierGrayDarker,
      contentTextStyle: _createTextStyle(
        color: bunnyIvory, // Dark snackbar background uses Bunny Ivory text
        fontSize: 16,
        fontWeight: FontWeight.w500, // Increased weight
      ),
      actionTextColor: snuggleBlue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 6.0, // Increased elevation
    ),

    // Chip theme with enhanced visibility
    chipTheme: ChipThemeData(
      backgroundColor: dividerLight.withAlpha(102), // Better background
      selectedColor: ovalGreen.withAlpha(77), // Oval Green selection
      labelStyle: _createTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600, // Increased weight
        color: textPrimaryLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: dividerLight, width: 0.5), // Subtle border
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: dialogLight,
      titleTextStyle: _createTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      contentTextStyle: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
    ),
  );

  /// Dark theme with enhanced visibility and contrast
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: primaryFontFamily,
    fontFamilyFallback: fontFamilyFallbacks,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: getTextColorForBackground(primaryDark),
      primaryContainer: primaryVariantDark,
      onPrimaryContainer: getTextColorForBackground(primaryVariantDark),
      secondary: secondaryDark,
      onSecondary: getTextColorForBackground(secondaryDark),
      secondaryContainer: secondaryVariantDark,
      onSecondaryContainer: getTextColorForBackground(secondaryVariantDark),
      tertiary: accentDark,
      onTertiary: getTextColorForBackground(accentDark),
      tertiaryContainer: accentDark.withAlpha(77),
      onTertiaryContainer: textPrimaryDark,
      error: errorDark,
      onError: getTextColorForBackground(errorDark),
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: dividerDark,
      outlineVariant: dividerDark.withAlpha(179),
      shadow: shadowDark,
      scrim: Colors.black87,
      inverseSurface: surfaceLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    dividerColor: dividerDark,

    // AppBar theme for dark mode with enhanced visibility
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: textPrimaryDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      titleTextStyle: _createTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimaryDark, size: 24),
    ),

    // Card theme for dark mode with enhanced visibility
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 3.0,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: dividerDark.withAlpha(102), width: 0.5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for dark mode with enhanced visibility
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: ovalGreen, // Keep Oval Green in dark mode
      unselectedItemColor: textSecondaryDark,
      elevation: 12.0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: _createTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: ovalGreen,
      ),
      unselectedLabelStyle: _createTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
      ),
    ),

    // FAB theme for dark mode
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ovalGreen, // Keep Oval Green for buttons
      foregroundColor: getTextColorForBackground(ovalGreen),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes for dark mode - Keep Oval Green on buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: getTextColorForBackground(ovalGreen),
        backgroundColor: ovalGreen, // Oval Green for buttons
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: _createTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: getTextColorForBackground(ovalGreen),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ovalGreen, // Oval Green for buttons
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: ovalGreen, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: _createTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ovalGreen,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ovalGreen, // Oval Green for buttons
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: _createTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ovalGreen,
        ),
      ),
    ),

    // Typography theme for dark mode with enhanced contrast
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration for dark mode
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: ovalGreen, width: 2.0), // Oval Green focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorDark, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorDark, width: 2.0),
      ),
      labelStyle: _createTextStyle(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: _createTextStyle(
        color: textSecondaryDark.withAlpha(179),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: _createTextStyle(
        color: errorDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch theme for dark mode
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen; // Oval Green for switches
        }
        return Colors.grey[600];
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen.withAlpha(77);
        }
        return Colors.grey[700];
      }),
    ),

    // Checkbox theme for dark mode
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen; // Oval Green for checkboxes
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(getTextColorForBackground(ovalGreen)),
      side: BorderSide(color: dividerDark, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),

    // Radio theme for dark mode
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ovalGreen; // Oval Green for radio buttons
        }
        return textSecondaryDark;
      }),
    ),

    // Progress indicators for dark mode
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ovalGreen, // Oval Green for progress
      linearTrackColor: ovalGreen.withAlpha(51),
      circularTrackColor: ovalGreen.withAlpha(51),
    ),

    // Slider theme for dark mode
    sliderTheme: SliderThemeData(
      activeTrackColor: ovalGreen, // Oval Green for sliders
      thumbColor: ovalGreen,
      overlayColor: ovalGreen.withAlpha(51),
      inactiveTrackColor: ovalGreen.withAlpha(77),
      valueIndicatorColor: ovalGreen,
      valueIndicatorTextStyle: _createTextStyle(
        color: getTextColorForBackground(ovalGreen),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    ),

    // Tab bar theme for dark mode
    tabBarTheme: TabBarThemeData(
      labelColor: ovalGreen, // Oval Green for tabs
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: ovalGreen,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ovalGreen,
      ),
      unselectedLabelStyle: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
      ),
    ),

    // Tooltip theme for dark mode
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withAlpha(230),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _createTextStyle(
        color: ovalGreen, // Light tooltip background uses Oval Green text
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar theme for dark mode
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryDark,
      contentTextStyle: _createTextStyle(
        color: ovalGreen, // Light snackbar background uses Oval Green text
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),

    // Chip theme for dark mode
    chipTheme: ChipThemeData(
      backgroundColor: dividerDark.withAlpha(77),
      selectedColor: ovalGreen.withAlpha(51), // Oval Green selection
      labelStyle: _createTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: dialogDark,
      titleTextStyle: _createTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      contentTextStyle: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
    ),
  );

  /// Helper method to build text theme with enhanced contrast
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textMediumEmphasis =
        isLight ? textSecondaryLight : textSecondaryDark;
    final Color textDisabled = isLight
        ? textSecondaryLight.withAlpha(128) // Better disabled contrast
        : textSecondaryDark.withAlpha(128);

    return TextTheme(
      // Display styles with enhanced contrast
      displayLarge: _createTextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w500, // Slightly increased weight
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displayMedium: _createTextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),
      displaySmall: _createTextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),

      // Headline styles with enhanced visibility
      headlineLarge: _createTextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineMedium: _createTextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineSmall: _createTextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),

      // Title styles with enhanced contrast
      titleLarge: _createTextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600, // Increased weight
        color: textHighEmphasis,
        letterSpacing: 0,
      ),
      titleMedium: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600, // Increased weight
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: _createTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600, // Increased weight
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Body styles with enhanced readability
      bodyLarge: _createTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500, // Increased weight
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: _createTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500, // Increased weight
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: _createTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500, // Increased weight
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles with enhanced visibility
      labelLarge: _createTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600, // Increased weight
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),
      labelMedium: _createTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600, // Increased weight
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
      labelSmall: _createTextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600, // Increased weight
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Helper method to get data text style for beautiful information display
  /// Uses secondary font family for data display with fallback
  static TextStyle getDataTextStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500, // Increased default weight
  }) {
    final Color textColor = isLight ? textPrimaryLight : textPrimaryDark;
    return TextStyle(
      fontFamily: secondaryFontFamily,
      fontFamilyFallback: [fallbackFontFamily, 'monospace'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0.5,
    );
  }

  /// Helper method to get status chip colors based on status
  static Color getStatusColor(String status, {required bool isLight}) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'healthy':
        return isLight ? accentLight : accentDark;
      case 'warning':
      case 'pending':
      case 'attention':
        return isLight ? warningLight : warningDark;
      case 'error':
      case 'critical':
      case 'urgent':
        return isLight ? errorLight : errorDark;
      default:
        return isLight ? primaryLight : primaryDark;
    }
  }

  /// Helper method to get primary font TextStyle
  static TextStyle getPrimaryFontStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return _createTextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Helper method to get secondary font TextStyle for headings and emphasis
  static TextStyle getSecondaryFontStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: secondaryFontFamily,
      fontFamilyFallback: [fallbackFontFamily, primaryFontFamily, 'serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}