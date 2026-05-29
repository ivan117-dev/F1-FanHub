import 'package:f1_fanhub/core/utils/race_name_translator.dart';
import 'package:f1_fanhub/presentation/viewmodels/race_results_viewmodel.dart';
import 'package:f1_fanhub/presentation/views/results/widgets/pit_stop_list.dart';
import 'package:f1_fanhub/presentation/views/results/widgets/qualifying_result_list.dart';
import 'package:f1_fanhub/presentation/views/results/widgets/race_result_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RaceResultsScreen extends StatefulWidget {
  final String round;
  final String raceName;

  const RaceResultsScreen({
    super.key,
    required this.round,
    required this.raceName,
  });

  @override
  State<RaceResultsScreen> createState() => _RaceResultsScreenState();
}

class _RaceResultsScreenState extends State<RaceResultsScreen> {
  static const Color appGreen = Color(0xFF69C56C);

  @override
  void initState() {
    super.initState();
    // Cargamos los datos apenas entramos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RaceResultsViewModel>().loadResults(widget.round);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RaceResultsViewModel>();
    final state = viewModel.state;

    if (state.isSuccess) {
      final data = state.data!;

      // 1. DEFINIMOS LAS PESTAÑAS DINÁMICAMENTE
      // Siempre tenemos Carrera y Clasificación
      List<Tab> tabs = [
        const Tab(text: "Carrera"),
        const Tab(text: "Clasificación"),
      ];

      List<Widget> tabViews = [
        RaceResultList(results: data.raceResults),
        QualifyingResultList(results: data.qualifyingResults),
      ];

      // A) Lógica Sprint
      if (data.sprintResults.isNotEmpty) {
        tabs.add(const Tab(text: "Sprint"));
        tabViews.add(RaceResultList(results: data.sprintResults));
      }

      // B) Lógica Pit Stops (NUEVO)
      if (data.pitStops.isNotEmpty) {
        tabs.add(const Tab(text: "Pit Stops"));
        tabViews.add(PitStopList(pitStops: data.pitStops));
      }

      return DefaultTabController(
        length: tabs.length, // Carrera, Clasificación, Sprint (si existe)
        child: Scaffold(
          appBar: AppBar(
            title: Text(RaceNameTranslator.translate(widget.raceName)),
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: Colors.grey[300], // Un gris claro
              labelColor: Colors.grey[200], // Un gris ligeramente más claro
              unselectedLabelColor: Colors.white70,
              indicatorWeight: 3,
              tabs: tabs,
            ),
          ),
          body: TabBarView(children: tabViews),
        ),
      );
    }

    Widget body;
    if (state.isLoading || state.isIdle) {
      body = const Center(child: CircularProgressIndicator(color: appGreen));
    } else if (state.hasError) {
      body = _buildError(state.message ?? 'Error cargando resultados');
    } else {
      body = _buildEmpty(state.message ?? 'Resultados aun no disponibles');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(RaceNameTranslator.translate(widget.raceName)),
      ),
      body: body,
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 10),
          Text(message),
          TextButton(
            onPressed: () =>
                context.read<RaceResultsViewModel>().loadResults(widget.round),
            child: const Text("Reintentar", style: TextStyle(color: appGreen)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 10),
          Text(message),
          TextButton(
            onPressed: () =>
                context.read<RaceResultsViewModel>().loadResults(widget.round),
            child: const Text("Reintentar", style: TextStyle(color: appGreen)),
          ),
        ],
      ),
    );
  }
}
