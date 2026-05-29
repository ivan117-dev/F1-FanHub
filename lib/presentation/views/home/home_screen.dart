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
    final state = viewModel.state;

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
      body: state.isLoading || state.isIdle
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF69C56C)),
            )
          : state.hasError
          ? _buildError(state.message ?? 'Error cargando el dashboard')
          : state.isEmpty
          ? _buildEmpty(state.message ?? 'Sin datos disponibles')
          : _buildContent(state.data!),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<HomeViewModel>().loadDashboard(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<HomeViewModel>().loadDashboard(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(HomeDashboard dashboard) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. TARJETA DE PRÓXIMA CARRERA
          if (dashboard.nextRace != null) ...[
            NextRaceCard(race: dashboard.nextRace!),
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
                items: dashboard.topDrivers,
                isDriver: true,
                onTapMore: () {
                  widget.onTabChangeRequest?.call(2);
                },
              ),
              const SizedBox(width: 16),
              // TARJETA CONSTRUCTORES
              MiniStandingsCard(
                title: "CONSTRUCTORES",
                items: dashboard.topConstructors,
                isDriver: false,
                onTapMore: () {
                  widget.onTabChangeRequest?.call(3);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),
          // 4. TARJETA DE ÚLTIMA CARRERA
          if (dashboard.lastRace != null) ...[
            LastRaceCard(
              race: dashboard.lastRace!,
              winner: dashboard.lastRaceWinner,
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
