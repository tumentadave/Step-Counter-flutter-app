import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the fitness tracking application.
class AppTheme {
  AppTheme._();

  // Organic Health Spectrum Color Palette
  static const Color primaryLight = Color(0xFF2ECC71); // Vibrant health green
  static const Color primaryVariantLight =
      Color(0xFF27AE60); // Deeper green for success
  static const Color secondaryLight =
      Color(0xFFE74C3C); // Alert red for warnings
  static const Color secondaryVariantLight =
      Color(0xFFE67E22); // Orange for moderate alerts
  static const Color accentLight = Color(0xFFF1C40F); // Motivational yellow
  static const Color backgroundLight = Color(0xFFF8F9FA); // Clean neutral base
  static const Color surfaceLight =
      Color(0xFFFFFFFF); // Pure white for content cards
  static const Color errorLight = Color(0xFFE74C3C); // Alert red
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight =
      Color(0xFF2C3E50); // High contrast dark
  static const Color onSurfaceLight = Color(0xFF2C3E50); // High contrast dark
  static const Color onErrorLight = Color(0xFFFFFFFF);

  // Dark theme colors (maintaining health-focused palette)
  static const Color primaryDark = Color(0xFF2ECC71);
  static const Color primaryVariantDark = Color(0xFF27AE60);
  static const Color secondaryDark = Color(0xFFE74C3C);
  static const Color secondaryVariantDark = Color(0xFFE67E22);
  static const Color accentDark = Color(0xFFF1C40F);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF2D2D2D);
  static const Color errorDark = Color(0xFFE74C3C);
  static const Color onPrimaryDark = Color(0xFF000000);
  static const Color onSecondaryDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFFFFFFF);
  static const Color onSurfaceDark = Color(0xFFFFFFFF);
  static const Color onErrorDark = Color(0xFFFFFFFF);

  // Glass morphism and overlay colors
  static const Color glassOverlayLight = Color(0x33FFFFFF); // 20% opacity white
  static const Color glassOverlayDark = Color(0x33000000); // 20% opacity black
  static const Color surfaceGlassLight = Color(0xD9FFFFFF); // 85% opacity white
  static const Color surfaceGlassDark =
      Color(0xD92D2D2D); // 85% opacity surface

  // Text colors with proper emphasis levels
  static const Color textHighEmphasisLight =
      Color(0xFF2C3E50); // High contrast dark
  static const Color textMediumEmphasisLight = Color(0xFF7F8C8D); // Muted gray
  static const Color textDisabledLight = Color(0x612C3E50); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xFFFFFFFF);
  static const Color textMediumEmphasisDark = Color(0xFF7F8C8D);
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  // Shadow colors for glass morphism effects
  static const Color shadowLight =
      Color(0x1A000000); // 0.1 opacity for subtle elevation
  static const Color shadowDark =
      Color(0x1AFFFFFF); // 0.1 opacity for dark theme

  // Divider colors
  static const Color dividerLight = Color(0x1A000000); // 0.1 opacity
  static const Color dividerDark = Color(0x1AFFFFFF); // 0.1 opacity

  /// Light theme with Contemporary Glass Minimalism
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryLight,
      onPrimary: onPrimaryLight,
      primaryContainer: primaryVariantLight,
      onPrimaryContainer: onPrimaryLight,
      secondary: secondaryLight,
      onSecondary: onSecondaryLight,
      secondaryContainer: secondaryVariantLight,
      onSecondaryContainer: onSecondaryLight,
      tertiary: accentLight,
      onTertiary: Color(0xFF000000),
      tertiaryContainer: accentLight.withValues(alpha: 0.2),
      onTertiaryContainer: Color(0xFF000000),
      error: errorLight,
      onError: onErrorLight,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      onSurfaceVariant: textMediumEmphasisLight,
      outline: dividerLight,
      outlineVariant: dividerLight.withValues(alpha: 0.5),
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: surfaceDark,
      onInverseSurface: onSurfaceDark,
      inversePrimary: primaryDark,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceGlassLight,
    dividerColor: dividerLight,

    // AppBar theme with glass morphism support
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceGlassLight,
      foregroundColor: onSurfaceLight,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurfaceLight,
      ),
      iconTheme: IconThemeData(color: onSurfaceLight),
      actionsIconTheme: IconThemeData(color: onSurfaceLight),
    ),

    // Card theme for contextual glass cards
    cardTheme: CardTheme(
      color: surfaceGlassLight,
      elevation: 2,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation with haptic feedback support
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceGlassLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textMediumEmphasisLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button with gradient support
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: onPrimaryLight,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Button themes with micro-feedback interactions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryLight,
        backgroundColor: primaryLight,
        elevation: 2,
        shadowColor: shadowLight,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: primaryLight, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Typography with Inter font family
    textTheme: _buildTextTheme(isLight: true),

    // Input decoration for contextual action sheets
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorLight, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textMediumEmphasisLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch theme for ambient status indicators
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Color(0xFFBDC3C7);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight.withValues(alpha: 0.3);
        }
        return Color(0xFFECF0F1);
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryLight;
        }
        return textMediumEmphasisLight;
      }),
    ),

    // Progress indicators for health metrics
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryLight,
      linearTrackColor: primaryLight.withValues(alpha: 0.2),
      circularTrackColor: primaryLight.withValues(alpha: 0.2),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryLight,
      thumbColor: primaryLight,
      overlayColor: primaryLight.withValues(alpha: 0.2),
      inactiveTrackColor: primaryLight.withValues(alpha: 0.3),
      trackHeight: 4,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
    ),

    // Tab bar theme for gesture-first navigation
    tabBarTheme: TabBarTheme(
      labelColor: primaryLight,
      unselectedLabelColor: textMediumEmphasisLight,
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceLight.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceLight,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceLight,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
    ),

    // Bottom sheet theme for contextual action sheets
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceLight,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceLight),
  );

  /// Dark theme with Contemporary Glass Minimalism
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: onPrimaryDark,
      primaryContainer: primaryVariantDark,
      onPrimaryContainer: onPrimaryDark,
      secondary: secondaryDark,
      onSecondary: onSecondaryDark,
      secondaryContainer: secondaryVariantDark,
      onSecondaryContainer: onSecondaryDark,
      tertiary: accentDark,
      onTertiary: Color(0xFF000000),
      tertiaryContainer: accentDark.withValues(alpha: 0.2),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: errorDark,
      onError: onErrorDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      onSurfaceVariant: textMediumEmphasisDark,
      outline: dividerDark,
      outlineVariant: dividerDark.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: surfaceLight,
      onInverseSurface: onSurfaceLight,
      inversePrimary: primaryLight,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardColor: surfaceGlassDark,
    dividerColor: dividerDark,

    // AppBar theme with glass morphism support
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceGlassDark,
      foregroundColor: onSurfaceDark,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onSurfaceDark,
      ),
      iconTheme: IconThemeData(color: onSurfaceDark),
      actionsIconTheme: IconThemeData(color: onSurfaceDark),
    ),

    // Card theme for contextual glass cards
    cardTheme: CardTheme(
      color: surfaceGlassDark,
      elevation: 2,
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation with haptic feedback support
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceGlassDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textMediumEmphasisDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button with gradient support
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: onPrimaryDark,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Button themes with micro-feedback interactions
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: onPrimaryDark,
        backgroundColor: primaryDark,
        elevation: 2,
        shadowColor: shadowDark,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: primaryDark, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Typography with Inter font family
    textTheme: _buildTextTheme(isLight: false),

    // Input decoration for contextual action sheets
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorDark),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: errorDark, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textMediumEmphasisDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Switch theme for ambient status indicators
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Color(0xFF7F8C8D);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark.withValues(alpha: 0.3);
        }
        return Color(0xFF34495E);
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(onPrimaryDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryDark;
        }
        return textMediumEmphasisDark;
      }),
    ),

    // Progress indicators for health metrics
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryDark,
      linearTrackColor: primaryDark.withValues(alpha: 0.2),
      circularTrackColor: primaryDark.withValues(alpha: 0.2),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryDark,
      thumbColor: primaryDark,
      overlayColor: primaryDark.withValues(alpha: 0.2),
      inactiveTrackColor: primaryDark.withValues(alpha: 0.3),
      trackHeight: 4,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
    ),

    // Tab bar theme for gesture-first navigation
    tabBarTheme: TabBarTheme(
      labelColor: primaryDark,
      unselectedLabelColor: textMediumEmphasisDark,
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: onSurfaceDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: onSurfaceDark,
      contentTextStyle: GoogleFonts.inter(
        color: surfaceDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
    ),

    // Bottom sheet theme for contextual action sheets
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surfaceDark,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ), dialogTheme: DialogThemeData(backgroundColor: surfaceDark),
  );

  /// Helper method to build text theme with Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),

      // Title styles for cards and components
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),

      // Body text for content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
      ),

      // Label styles for buttons and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Data text theme using JetBrains Mono for fitness metrics
  static TextTheme dataTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;

    return TextTheme(
      // Large data displays (step counts, distances)
      displayLarge: GoogleFonts.jetBrainsMono(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      displayMedium: GoogleFonts.jetBrainsMono(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      displaySmall: GoogleFonts.jetBrainsMono(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),

      // Medium data displays (time, calories)
      headlineLarge: GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
      ),
      headlineMedium: GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),
      headlineSmall: GoogleFonts.jetBrainsMono(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),

      // Small data displays (timestamps, small metrics)
      titleLarge: GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
      ),
      titleMedium: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
      ),
      titleSmall: GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
      ),
    );
  }

  /// Glass morphism decoration helper
  static BoxDecoration glassDecoration({
    required bool isLight,
    double borderRadius = 16.0,
    double opacity = 0.85,
  }) {
    return BoxDecoration(
      color: isLight
          ? surfaceLight.withValues(alpha: opacity)
          : surfaceDark.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isLight ? dividerLight : dividerDark,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isLight ? shadowLight : shadowDark,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}
