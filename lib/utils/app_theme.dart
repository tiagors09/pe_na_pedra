import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  drawerTheme: const DrawerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(
      0xFFF5D204,
    ),
    brightness: Brightness.light,
  ),
  cardTheme: const CardThemeData(
    elevation: 0.0,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
    scrolledUnderElevation: 0.0,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: const Color(
      0xFFF5D204,
    ),
    elevation: 0,
    indicatorColor: const Color(
      0xFFFEFEFE,
    ),
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        40,
      ),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: Color(
              0xFF745F04,
            ),
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: Color(
            0xFF745F04,
          ),
          fontWeight: FontWeight.w500,
        );
      },
    ),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: Color(0xFF745F04),
          );
        }
        return const IconThemeData(
          color: Color(0xFF745F04),
        );
      },
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0.0),
      backgroundColor: WidgetStateProperty.all(const Color(0xFFF5D204)),
      foregroundColor: WidgetStateProperty.all(const Color(0xFF745F04)),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return Colors.transparent;
          }
          return null;
        },
      ),
      splashFactory: NoSplash.splashFactory,
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(
        0xFF745F04,
      ),
    ),
  ),
);
