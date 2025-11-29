import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../races/calendar_screen.dart';
import '../standings/driver_standings_screen.dart';
import '../standings/constructor_standings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onTabChangeRequest: _onTabChanged),
      const CalendarScreen(),
      const DriverStandingsScreen(),
      const ConstructorStandingsScreen(),
    ];

    //PopScope intercepta el botón Atrás
    return PopScope(
      // canPop: false indica que nosotros manejaremos la lógica manualmente
      // si NO estamos en la pestaña 0.
      // Si _currentIndex == 0, canPop es true y deja salir de la app.
      canPop: _currentIndex == 0,

      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          // Si Flutter ya permitió salir (porque canPop era true), no hacemos nada.
          return;
        }

        // Si estamos aquí, es porque canPop era false (estábamos en otra pestaña).
        // Entonces, volvemos a la pestaña de Inicio.
        setState(() {
          _currentIndex = 0;
        });
      },

      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabChanged,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            elevation: 0,
            selectedItemColor: Theme.of(
              context,
            ).colorScheme.primary, // ← Añade esto
            unselectedItemColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6), // ← Añade esto
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month),
                label: 'Calendario',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_motorsports_outlined),
                activeIcon: Icon(Icons.sports_motorsports),
                label: 'Pilotos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.build_outlined),
                activeIcon: Icon(Icons.build),
                label: 'Constructores',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
