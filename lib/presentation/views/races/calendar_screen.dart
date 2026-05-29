import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/presentation/viewmodels/calendar_viewmodel.dart';
import 'package:f1_fanhub/presentation/common/view_state.dart';
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
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendario de Carreras',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: _buildBody(viewModel, state),
    );
  }

  Widget _buildBody(CalendarViewModel viewModel, ViewState<List<Race>> state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.message ?? 'Error cargando calendario'),
            TextButton(
              onPressed: () => viewModel.getSchedule(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(state.message ?? 'Sin carreras disponibles'),
            TextButton(
              onPressed: () => viewModel.getSchedule(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final races = state.data ?? [];

    // LISTA DE TARJETAS OPTIMIZADA
    return RefreshIndicator(
      // Color de la bolita de carga
      onRefresh: () async {
        // Llamamos al método de forzar actualización
        await context.read<CalendarViewModel>().refreshSchedule();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 20),
        itemCount: races.length,
        itemBuilder: (context, index) {
          final race = races[index];

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
