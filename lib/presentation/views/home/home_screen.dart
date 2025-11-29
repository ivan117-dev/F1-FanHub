import 'package:f1_fanhub/presentation/viewmodels/home_viewmodel.dart';
import 'package:f1_fanhub/presentation/views/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/next_race_card.dart';
import 'widgets/mini_standings_card.dart';
import 'widgets/last_race_card.dart';

class HomeScreen extends StatefulWidget {
  // Callback para cambiar de tab desde aquí
  final Function(int)? onTabChangeRequest;

  const HomeScreen({super.key, this.onTabChangeRequest});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'F1 FanHub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF69C56C)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20), // ← Cambiado
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TARJETA DE PRÓXIMA CARRERA
                  if (viewModel.nextRace != null) ...[
                    NextRaceCard(race: viewModel.nextRace!),
                  ] else ...[
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Fin de temporada"),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 2. TÍTULO TABLA DE POSICIONES
                  const Text(
                    "Tabla de Posiciones",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // 3. ROW CON LAS DOS TABLAS (PILOTOS Y CONSTRUCTORES)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TARJETA PILOTOS
                      MiniStandingsCard(
                        title: "PILOTOS",
                        items: viewModel.topDrivers,
                        isDriver: true,
                        onTapMore: () {
                          widget.onTabChangeRequest?.call(2);
                        },
                      ),
                      const SizedBox(width: 16), // Espaciado entre tarjetas
                      // TARJETA CONSTRUCTORES
                      MiniStandingsCard(
                        title: "CONSTRUCTORES",
                        items: viewModel.topConstructors,
                        isDriver: false,
                        onTapMore: () {
                          widget.onTabChangeRequest?.call(2);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  // 4. TARJETA DE ÚLTIMA CARRERA
                  // Solo la mostramos si existe una carrera anterior (ej. no estamos en la primera fecha)
                  if (viewModel.lastRace != null) ...[
                    LastRaceCard(
                      race: viewModel.lastRace!,
                      winner:
                          viewModel.lastRaceWinner, // <--- Pasamos el ganador
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
    );
  }
}
