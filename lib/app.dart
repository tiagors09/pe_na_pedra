import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/app_theme.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';
import 'package:pe_na_pedra/views/home_view.dart';
import 'package:pe_na_pedra/views/login_view.dart';
import 'package:pe_na_pedra/views/users_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pé na Pedra',
      theme: appTheme,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeView(),
        AppRoutes.login: (context) => const LoginView(),
        AppRoutes.editProfile: (context) => const EditProfileView(),
        AppRoutes.users: (context) => const UsersView(),
      },
    );
  }
}
