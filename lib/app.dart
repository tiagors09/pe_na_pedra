import 'package:flutter/material.dart';
import 'package:pe_na_pedra/utils/app_routes.dart';
import 'package:pe_na_pedra/utils/app_theme.dart';
import 'package:pe_na_pedra/views/calendar_view.dart';
import 'package:pe_na_pedra/views/edit_profile_view.dart';
import 'package:pe_na_pedra/views/home_view.dart';
import 'package:pe_na_pedra/views/login_view.dart';
import 'package:pe_na_pedra/views/hikkers_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pe_na_pedra/views/route_detail_view.dart';
import 'package:pe_na_pedra/views/route_form_view.dart';
import 'package:pe_na_pedra/views/routes_view.dart';
import 'package:pe_na_pedra/views/scheduled_trail_form_view.dart';
import 'package:pe_na_pedra/views/track_route_view.dart';

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
        AppRoutes.users: (context) => const HikkersView(),
        AppRoutes.calendar: (context) => const CalendarView(),
        AppRoutes.routes: (context) => const RoutesView(),
        AppRoutes.routeForm: (context) => const RouteFormView(),
        AppRoutes.trackRoute: (context) => const TrackRouteView(),
        AppRoutes.scheduledTrailForm: (context) =>
            const ScheduledTrailFormView(),
        AppRoutes.routeDetails: (context) => const RouteDetailsView(),
      },
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
