import 'package:flutter/material.dart';
import 'constants/colors.dart';
import 'screens/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ガチャ管理アプリ',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Hiragino Sans',

        /* 共通設定 */
        // カラー
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.whiteBackground,
          onSurface: AppColors.basicText,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.appBarText,
          elevation: 0,
          centerTitle: true,
        ),

        // BottomNav
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.whiteBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),

        // カード
        cardTheme: CardThemeData(
          color: AppColors.whiteBackground,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // ボタン
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.appBarText,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // テキスト
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.whiteBackground,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}