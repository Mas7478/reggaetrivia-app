import 'package:flutter/material.dart';

class ReggaeColors {
  static const Color green = Color(0xFF1B873F);
  static const Color yellow = Color(0xFFFBC02D);
  static const Color red = Color(0xFFD32F2F);

  static const Color background = Color(0xFF101410);
  static const Color surface = Color(0xFF1A1F1A);
  static const Color card = Color(0xFF212721);

  static const Color white = Colors.white;
  static const Color grey = Color(0xFFBFC7BF);

  static const List<Color> rastaStripe = [green, yellow, red];

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [green, Color(0xFF0D3A1F), background],
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: green,
        secondary: yellow,
        tertiary: red,
        error: red,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 3,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0x22FBC02D), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: yellow,
          side: const BorderSide(
            color: yellow,
            width: 2,
          ),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: yellow,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: yellow,
        foregroundColor: Colors.black,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF262E26),
        contentTextStyle: const TextStyle(color: white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x33FBC02D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: yellow,
            width: 2,
          ),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: yellow,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: white,
        ),
        bodyLarge: TextStyle(
          color: white,
        ),
        bodyMedium: TextStyle(
          color: grey,
        ),
      ),
    );
  }
}

class RastaAccentBar extends StatelessWidget {
  final double height;

  const RastaAccentBar({super.key, this.height = 6});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ReggaeColors.rastaStripe
          .map(
            (color) => Expanded(
              child: Container(height: height, color: color),
            ),
          )
          .toList(),
    );
  }
}
