import 'package:f1_fanhub/core/theme/app_theme.dart';
import 'package:f1_fanhub/presentation/viewmodels/home_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/race_results_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/theme_viewmodel.dart';
import 'package:f1_fanhub/presentation/views/home/main_screen.dart';
import 'package:f1_fanhub/presentation/viewmodels/calendar_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/constructor_standings_viewmodel.dart';
import 'package:f1_fanhub/presentation/viewmodels/driver_standings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/di/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos fechas
  await initializeDateFormatting('es_MX', null);

  // Inicializamos TODAS las dependencias
  await di.setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<CalendarViewModel>()),
        ChangeNotifierProvider(
          create: (_) => di.sl<DriverStandingsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<ConstructorStandingsViewModel>(),
        ),
        ChangeNotifierProvider(create: (_) => di.sl<RaceResultsViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<HomeViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<ThemeViewModel>()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'F1 FanHub',
            debugShowCheckedModeBanner: false,

            // ASIGNAR LOS TEMAS QUE CREASTE EN APPTHEME
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            // DECIDIR CUÁL USAR SEGÚN EL VIEWMODEL
            themeMode: themeViewModel.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
