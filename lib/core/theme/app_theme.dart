import 'package:flutter/material.dart';

class AppTheme {
  // Primary color palette - More vibrant
  static const Color primaryColor = Color(0xFF6A11CB); // Vivid purple
  static const Color accentColor = Color(0xFF2575FC); // Electric blue
  static const Color tertiaryColor = Color(0xFFFF0099); // Hot pink

  // Background colors - Richer dark tones
  static const Color backgroundColor = Color(0xFF070317); // Deep violet-black
  static const Color surfaceColor = Color(0xFF130B2B); // Dark purple-blue
  static const Color cardColor = Color(0xFF1D1033); // Rich purple surface
  static const Color elevatedColor = Color(0xFF271646); // Elevated dark purple

  // Text colors - Brighter for better visibility
  static const Color textColor = Colors.white;
  static const Color secondaryTextColor = Color(0xFFD6D8F3);
  static const Color disabledTextColor = Color(0xFF8A82B8);

  // Accent colors for music visualizations and highlights - Ultra vibrant
  static const Color highlightColor = Color(0xFF00F2EA); // Neon aqua
  static const Color dangerColor = Color(0xFFFF003D); // Vibrant red
  static const Color warningColor = Color(0xFFFFE500); // Bright yellow

  // Vibrant Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF2575FC), Color(0xFFFF0099)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [backgroundColor, surfaceColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [Color(0xFF00F2EA), Color(0xFFFF00D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient energyGradient = LinearGradient(
    colors: [Color(0xFFFFE500), Color(0xFFFF003D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      tertiary: tertiaryColor,
      surface: Colors.white,
      background: const Color(0xFFF8F9FD),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF2C3A47),
      onBackground: const Color(0xFF2C3A47),
      error: dangerColor,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: const Color(0xFF2C3A47),
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: primaryColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF2C3A47),
        fontWeight: FontWeight.bold,
        fontSize: 36,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        color: Color(0xFF2C3A47),
        fontWeight: FontWeight.bold,
        fontSize: 30,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF2C3A47),
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF2C3A47),
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF2C3A47),
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF2C3A47),
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF2C3A47),
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF2C3A47),
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 1.25,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: const Color(0xFF9E9E9E),
      indicatorColor: primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    ),
    iconTheme: IconThemeData(color: primaryColor, size: 24),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: primaryColor.withOpacity(0.2),
      thumbColor: primaryColor,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      tertiary: tertiaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textColor,
      onBackground: textColor,
      error: dangerColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: primaryColor),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 36,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 30,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFFABB2BF),
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFABB2BF),
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      labelLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 1.25,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2F3748),
      thickness: 1,
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: secondaryTextColor,
      indicatorColor: primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    ),
    iconTheme: IconThemeData(color: secondaryTextColor, size: 24),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: primaryColor.withOpacity(0.2),
      thumbColor: primaryColor,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryTextColor,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: elevatedColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: elevatedColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(color: Color(0xFFABB2BF), fontSize: 16),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: elevatedColor,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: elevatedColor,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.white),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: surfaceColor,
      selectedIconTheme: IconThemeData(color: primaryColor),
      unselectedIconTheme: IconThemeData(color: secondaryTextColor),
      selectedLabelTextStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: TextStyle(color: secondaryTextColor),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cardColor,
      disabledColor: elevatedColor,
      selectedColor: primaryColor,
      secondarySelectedColor: accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // Utils
  static BoxDecoration gradientBoxDecoration({
    double borderRadius = 16.0,
    LinearGradient gradient = primaryGradient,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration frostedGlassEffect() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: -2,
        ),
      ],
    );
  }

  static BoxDecoration neonBorderEffect() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: highlightColor, width: 2.0),
      boxShadow: [
        BoxShadow(
          color: highlightColor.withOpacity(0.6),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static BoxDecoration glowEffect(Color color) {
    return BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 18,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
