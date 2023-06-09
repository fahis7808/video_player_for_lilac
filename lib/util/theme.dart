import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const double borderRadius = 10;
// const double borderRadius2 = 20;

class AppTheme {
  static final Typography _typography = Typography.material2021();

  static ThemeData getThemeData(ThemeMode mode) {
    final data = mode == ThemeMode.light ? LightThemStyle() : DarkThemeStyle();
    return ThemeData(
        brightness: data.brightness,
        useMaterial3: true,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: data.colorScheme.primary,
          selectionColor: data.colorScheme.primary.withOpacity(0.5),
        ),
        dialogBackgroundColor: data.colorScheme.background,
        colorScheme: data.colorScheme,
        typography: _typography,
        iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(
              iconSize: 30,
              foregroundColor: data.colorScheme.primary,
            )),
        iconTheme: IconThemeData(
          color: data.colorScheme.onBackground,
          size: 30,
        ),
        cardTheme: CardTheme(
            surfaceTintColor: data.colorScheme.surface,
            color: data.colorScheme.surface,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            )),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: data.colorScheme.background,
          collapsedBackgroundColor: data.colorScheme.background,
        ),
        elevatedButtonTheme: _buttonStyle(data.colorScheme, data.textTheme),
        cardColor: data.colorScheme.surface,
        listTileTheme: ListTileThemeData(
            tileColor: data.colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            )),


        scrollbarTheme: ScrollbarThemeData(
          thickness: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return green, otherwise blue
            if (states.contains(MaterialState.pressed)) {
              return 5;
            }
            return 5;
          }),
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return data.colorScheme.primary;
            }
            return data.colorScheme.primary;
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
            suffixIconColor: data.colorScheme.primary,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
            isDense: false,
            filled: true,
            fillColor: data.colorScheme.inversePrimary.withOpacity(0.1),
            errorStyle: data.textTheme.bodySmall?.copyWith(color: data.colorScheme.error),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.7,
                  color: data.colorScheme.tertiary,
                ),
                gapPadding: 0,
                borderRadius: BorderRadius.circular(borderRadius) //<-- SEE HERE
            ),
            prefixIconColor: data.colorScheme.outline,
            focusColor: Colors.red,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.7,
                  color: data.colorScheme.tertiary,
                ),
                gapPadding: 0,
                borderRadius: BorderRadius.circular(borderRadius) //<-- SEE HERE
            ),
            labelStyle: data.textTheme.bodyMedium?.copyWith(color: data.colorScheme.secondary),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.7,
                  color: data.colorScheme.tertiary,
                ),
                gapPadding: 0,
                borderRadius: BorderRadius.circular(borderRadius) //<-- SEE HERE
            )),
        textTheme: data.textTheme,
        dialogTheme: DialogTheme(
          backgroundColor: data.colorScheme.background,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          contentTextStyle: data.textTheme.bodySmall,
          titleTextStyle: data.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          //actionsPadding: const EdgeInsets.only(left: 20,right: 20,bottom: 30,top: 5)
        ),
        drawerTheme: DrawerThemeData(
            backgroundColor: data.colorScheme.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            )),
        dividerTheme: DividerThemeData(thickness: 0.8, color: data.colorScheme.outline.withOpacity(.3)),
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        scaffoldBackgroundColor: data.colorScheme.background,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: data.colorScheme.background,
          selectedIconTheme: IconThemeData(color: data.colorScheme.secondary, size: 35),
          unselectedIconTheme: IconThemeData(color: data.colorScheme.outline, size: 25),
          selectedLabelStyle: const TextStyle(color: Colors.green),
          selectedItemColor: data.colorScheme.secondary,
          showUnselectedLabels: true,
          showSelectedLabels: false,
          unselectedItemColor: data.colorScheme.outline,
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
          ),
          type: BottomNavigationBarType.fixed,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.red,
          indicatorColor: Colors.red,
        ));
  }

  static ThemeData reverseThemeData(ThemeData data) {
    return data.copyWith(
        textTheme: data.textTheme.copyWithTextTheme(color: data.colorScheme.onSurfaceVariant),
        colorScheme: data.colorScheme.copyWith(
          background: data.colorScheme.surfaceVariant,
          onBackground: data.colorScheme.onSurfaceVariant,
        ),
        scaffoldBackgroundColor: data.colorScheme.surfaceVariant,
        inputDecorationTheme: data.inputDecorationTheme.copyWith(
          filled: true,
          fillColor: data.colorScheme.background.toVariant(1600),
        ));
  }

  static ThemeData gradientTheme(ThemeData data) {
    return data.copyWith(iconTheme: data.iconTheme.copyWith(color: data.colorScheme.onPrimary), textTheme: data.textTheme.copyWithTextTheme(color: data.colorScheme.onPrimary));
  }

  static ElevatedButtonThemeData _buttonStyle(ColorScheme colorScheme, TextTheme textTheme) {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            textStyle: textTheme.bodyMedium));
  }

}
abstract class ThemeStyle {
  Brightness get brightness;

  final Typography _typography = Typography.material2021();
  final ThemeMode mode;

  // ThemeData get data;
  ColorScheme get colorScheme;

  TextTheme get textTheme;

  ThemeStyle(
      this.mode,
      );
}

class LightThemStyle extends ThemeStyle {
  LightThemStyle() : super(ThemeMode.light);

  @override
  ColorScheme get colorScheme => lightColorScheme;

  @override
  TextTheme get textTheme => _typography.englishLike.copyWithTextTheme(colorScheme: colorScheme);

  @override
  Brightness get brightness => Brightness.light;
}

class DarkThemeStyle extends ThemeStyle {
  @override
  ColorScheme get colorScheme => darkColorScheme;

  DarkThemeStyle() : super(ThemeMode.dark);

  @override
  TextTheme get textTheme => _typography.englishLike.copyWithTextTheme(colorScheme: colorScheme);

  @override
  Brightness get brightness => Brightness.dark;
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff00AFAD), onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF456805), onPrimaryContainer: Color(0xFFFFFFFF),
  inversePrimary: Color(0xFF0D91B9),
  secondary: Color(0xFF00286B), onSecondary: Color(0xFFF5F9FF),
  secondaryContainer: Color(0xFF011921),
  onSecondaryContainer: Color(0xFF001F27),
  tertiary: Color(0xFFF5F9FF), onTertiary: Color(0xFF000000),
  tertiaryContainer: Color(0xFFF7D8FF), onTertiaryContainer: Color(0xFF271430),
  background: Color(0xFFFFFFFF), onBackground: Color(0xFF000000),
  surface: Color(0xFFFFFFFF), onSurface: Color(0xFF1A1C1E),
  surfaceTint: Color(0xFF005FAF),
  error: Color(0xFFEA1505), onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6), onErrorContainer: Color(0xFFB00020),
  surfaceVariant: Color(0xFF49454F), onSurfaceVariant: Color(0xFFFFFFFF),
  inverseSurface: Color(0xFF2F3033), onInverseSurface: Color(0xFFF1F0F4),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFF534F4E),
  outline: Color(0xFF79747E),
  scrim: Color(0xFF140201),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff0468be),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF004786),
  onPrimaryContainer: Color(0xFFFFFFFF),
  inversePrimary: Color(0xFF005FAF),
  secondary: Color(0xFF52A98A),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF004E5F),
  onSecondaryContainer: Color(0xFFB3EBFF),
  tertiary: Color(0xFF1DB9DD),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF553F5D),
  onTertiaryContainer: Color(0xFFF7D8FF),
  background: Color(0xFF2A2D35),
  onBackground: Color(0xFFFFFFFF),
  surface: Color(0xFF313640),
  onSurface: Color(0xFFE3E2E6),
  surfaceTint: Color(0xFFFFFFFF),
  error: Color(0xFFEA1505),
  onError: Color(0xFFE8E5E5),
  errorContainer: Color(0xFFFFB70A),
  onErrorContainer: Color(0xFFB00020),
  surfaceVariant: Color(0x26FFFFFF),
  onSurfaceVariant: Color(0xFFC3C6CF),
  inverseSurface: Color(0xFFE3E2E6),
  onInverseSurface: Color(0xFF1A1C1E),
  outline: Color(0x26FFFFFF),
  shadow: Color(0xFF000000),
);


extension CopyWithTextTheme on TextTheme {
  TextTheme copyWithTextTheme({Color? color, ColorScheme? colorScheme}) {
    final fontFamily = GoogleFonts.lato().fontFamily;
    return copyWith(
      bodySmall: bodySmall?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 12),
      bodyMedium: bodyMedium?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 14),
      bodyLarge: bodyLarge?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w500),
      displaySmall: displaySmall?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 36),
      displayMedium: displayMedium?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 45),
      displayLarge: displayLarge?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 57),
      headlineSmall: headlineSmall?.copyWith(color: colorScheme?.primary ?? color, fontFamily: fontFamily, fontWeight: FontWeight.bold, fontSize: 20),
      headlineMedium: headlineMedium?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 24),
      headlineLarge: headlineLarge?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 32),
      titleSmall: titleSmall?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 14),
      titleMedium: titleMedium?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 16),
      titleLarge: titleLarge?.copyWith(color: colorScheme?.onBackground ?? color, fontFamily: fontFamily, fontSize: 22,fontWeight: FontWeight.bold),
      labelSmall: labelSmall?.copyWith(color: colorScheme?.outline ?? color, fontFamily: fontFamily, fontSize: 12),
      labelMedium: labelMedium?.copyWith(color: colorScheme?.outline ?? color, fontFamily: fontFamily, fontSize: 12),
      labelLarge: labelLarge?.copyWith(color: colorScheme?.outline ?? color, fontFamily: fontFamily, fontSize: 14),
    );
  }
}

extension ColorExt on Color {
  Color toVariant(int variantNumber) {
    Color color = this;
    int baseRed = color.red;
    int baseGreen = color.green;
    int baseBlue = color.blue;
    int targetRed = Colors.white.red;
    int targetGreen = Colors.white.green;
    int targetBlue = Colors.white.blue;

    int variantRed = baseRed + ((targetRed - baseRed) * variantNumber ~/ 100);
    int variantGreen =
        baseGreen + ((targetGreen - baseGreen) * variantNumber ~/ 100);
    int variantBlue =
        baseBlue + ((targetBlue - baseBlue) * variantNumber ~/ 100);

    return Color.fromRGBO(variantRed, variantGreen, variantBlue, 1);
  }
}