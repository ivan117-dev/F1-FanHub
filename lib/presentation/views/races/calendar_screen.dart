import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f1_fanhub/presentation/viewmodels/calendar_viewmodel.dart';
import 'widgets/race_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Estado local para manejar el acordeón
  // Almacena el ID de la carrera expandida. Si es null, ninguna está expandida.
  String? _expandedRaceId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarViewModel>().getSchedule();
    });
  }

  // Lógica del acordeón
  void _handleCardTap(String raceId) {
    setState(() {
      if (_expandedRaceId == raceId) {
        // Si toco la misma que está abierta, la cierro
        _expandedRaceId = null;
      } else {
        // Si toco otra, abro esa (y la anterior se cierra sola al cambiar el ID)
        _expandedRaceId = raceId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendario de Carreras',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(CalendarViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(viewModel.errorMessage!),
            TextButton(
              onPressed: () => viewModel.getSchedule(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    // LISTA DE TARJETAS OPTIMIZADA
    return RefreshIndicator(
      // Color de la bolita de carga (tu verde)
      onRefresh: () async {
        // Llamamos al método de forzar actualización
        await context.read<CalendarViewModel>().refreshSchedule();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 20),
        itemCount: viewModel.races.length,
        itemBuilder: (context, index) {
          final race = viewModel.races[index];

          return RaceCard(
            race: race,
            // Le decimos al card si debe estar expandido o no
            isExpanded: _expandedRaceId == race.id,
            // Pasamos la función para cambiar el estado
            onTap: () => _handleCardTap(race.id),
          );
        },
      ),
    );
  }
}
