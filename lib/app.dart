import 'package:flutter/material.dart';
import 'package:pe_na_pedra/views/home_view.dart';
import 'package:pe_na_pedra/views/login_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pé na Pedra',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFFF5D204,
          ),
          brightness: Brightness.light,
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
                  color: Color(0xFF745F04), // Ícone ativo
                );
              }
              return const IconThemeData(
                color: Color(0xFF745F04), // Ícone inativo
              );
            },
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFFF5D204,
            ),
            foregroundColor: const Color(
              0xFF745F04,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
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
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeView(),
        '/login': (context) => const LoginView(),
      },
    );
  }
}
