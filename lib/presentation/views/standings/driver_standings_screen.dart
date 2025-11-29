import 'package:f1_fanhub/core/utils/flags_helper.dart';
import 'package:f1_fanhub/core/utils/image_helper.dart';
import 'package:f1_fanhub/core/utils/nationality_translator.dart';
import 'package:f1_fanhub/presentation/viewmodels/driver_standings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'driver_detail_screen.dart';

class DriverStandingsScreen extends StatefulWidget {
  const DriverStandingsScreen({super.key});

  @override
  State<DriverStandingsScreen> createState() => _DriverStandingsScreenState();
}

class _DriverStandingsScreenState extends State<DriverStandingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverStandingsViewModel>().loadStandings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DriverStandingsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campeonato de Pilotos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: _buildBody(viewModel, theme),
    );
  }

  Widget _buildBody(DriverStandingsViewModel viewModel, ThemeData theme) {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.refreshStandings(),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // Calcular máximo de puntos para la barra de progreso
    final maxPoints = viewModel.drivers.isNotEmpty
        ? double.parse(viewModel.drivers.first.points)
        : 100.0;

    return RefreshIndicator(
      color: theme.colorScheme.primary,
      onRefresh: () async => await viewModel.refreshStandings(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        itemCount: viewModel.drivers.length,
        itemBuilder: (context, index) {
          final standing = viewModel.drivers[index];
          final isTop3 = index < 3;
          final points = double.parse(standing.points);
          final percentage = maxPoints > 0 ? points / maxPoints : 0.0;

          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverDetailScreen(
                      driverId: standing.driver.id,
                      driverStanding: standing,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  // Contenido principal
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // POSICIÓN con medalla para top 3
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getPositionColor(theme, index + 1),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isTop3
                                ? [
                                    BoxShadow(
                                      color: _getPositionColor(
                                        theme,
                                        index + 1,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              standing.position,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isTop3
                                    ? Colors.white
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // FOTO DEL PILOTO
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            image: DecorationImage(
                              image: AssetImage(
                                ImageHelper.getDriverImage(standing.driver.id),
                              ),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // INFO DEL PILOTO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nombre
                              Text(
                                "${standing.driver.givenName} ${standing.driver.familyName}",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),

                              // Equipo con logo
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.asset(
                                      ImageHelper.getConstructorLogo(
                                        standing.constructor.id,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      standing.constructor.name,
                                      style: theme.textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Nacionalidad con bandera
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        FlagHelper.getFlagPath(
                                          standing.driver.nationality,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    NationalityTranslator.translate(
                                      standing.driver.nationality,
                                    ),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // PUNTOS Y VICTORIAS
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                standing.points,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (standing.wins != "0") ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFFFD700),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.emoji_events,
                                      size: 12,
                                      color: Color(0xFFFFD700),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      standing.wins,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFD700),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Barra de progreso
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 4,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      valueColor: AlwaysStoppedAnimation(
                        isTop3
                            ? _getPositionColor(theme, index + 1)
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getPositionColor(ThemeData theme, int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Oro
      case 2:
        return const Color(0xFFC0C0C0); // Plata
      case 3:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return theme.colorScheme.primary.withValues(alpha: 0.2);
    }
  }
}
