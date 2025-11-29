import 'package:f1_fanhub/core/di/service_locator.dart';
import 'package:f1_fanhub/core/utils/flags_helper.dart';
import 'package:f1_fanhub/core/utils/image_helper.dart';
import 'package:f1_fanhub/core/utils/nationality_translator.dart';
import 'package:f1_fanhub/core/utils/race_name_translator.dart';
import 'package:f1_fanhub/core/utils/status_translator.dart';
import 'package:f1_fanhub/domain/entities/standing.dart';
import 'package:f1_fanhub/presentation/viewmodels/driver_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class DriverDetailScreen extends StatefulWidget {
  final String driverId;
  final DriverStanding driverStanding;

  const DriverDetailScreen({
    super.key,
    required this.driverId,
    required this.driverStanding,
  });

  @override
  State<DriverDetailScreen> createState() => _DriverDetailScreenState();
}

class _DriverDetailScreenState extends State<DriverDetailScreen> {
  bool _didInitialLoad = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider<DriverDetailViewModel>(
      create: (context) => sl<DriverDetailViewModel>(param1: widget.driverId),
      child: Consumer<DriverDetailViewModel>(
        builder: (context, viewModel, child) {
          if (!_didInitialLoad) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadProgression();
              _didInitialLoad = true;
            });
          }

          final driver = widget.driverStanding.driver;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // AppBar con gradiente y foto del piloto
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calcular si el AppBar está expandido o colapsado
                      final isCollapsed =
                          constraints.biggest.height <=
                          kToolbarHeight +
                              MediaQuery.of(context).padding.top +
                              20;

                      return FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gradiente de fondo
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                            // Contenido - siempre visible
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 40),
                                    // Foto del piloto circular
                                    AnimatedOpacity(
                                      opacity: isCollapsed ? 0.0 : 1.0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                              blurRadius: 15,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipOval(
                                          child: Image.asset(
                                            ImageHelper.getDriverImage(
                                              driver.id,
                                            ),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 26),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          "${driver.givenName} ${driver.familyName}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        centerTitle: true,
                        titlePadding: const EdgeInsets.only(
                          left: 16,
                          bottom: 16,
                        ),
                      );
                    },
                  ),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Card con estadísticas principales
                      _buildStatsCard(theme, driver),

                      // Card del equipo
                      _buildTeamCard(theme),

                      // Gráfico de progresión
                      _buildProgressionSection(theme, viewModel),

                      // Lista de resultados recientes
                      _buildRecentResultsSection(theme, viewModel),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(ThemeData theme, Driver driver) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Nacionalidad con bandera grande
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      FlagHelper.getFlagPath(driver.nationality),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  NationalityTranslator.translate(driver.nationality),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Estadísticas en grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  theme,
                  Icons.workspace_premium,
                  widget.driverStanding.position,
                  'Posición',
                  isPrimary: true,
                ),
                _buildStatItem(
                  theme,
                  Icons.stars,
                  widget.driverStanding.points,
                  'Puntos',
                ),
                _buildStatItem(
                  theme,
                  Icons.emoji_events,
                  widget.driverStanding.wins,
                  'Victorias',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String value,
    String label, {
    bool isPrimary = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  )
                : null,
            color: isPrimary
                ? null
                : theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isPrimary ? Colors.white : theme.colorScheme.primary,
            size: 32,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPrimary ? theme.colorScheme.primary : null,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamCard(ThemeData theme) {
    final constructor = widget.driverStanding.constructor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Logo del equipo
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Image.asset(
                ImageHelper.getConstructorLogo(constructor.id),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ESCUDERÍA',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    constructor.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressionSection(
    ThemeData theme,
    DriverDetailViewModel viewModel,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.show_chart,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Progresión en Carrera",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (viewModel.isLoading)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (viewModel.errorMessage != null)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Error: ${viewModel.errorMessage}",
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              _buildProgressionChart(theme, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressionChart(
    ThemeData theme,
    DriverDetailViewModel viewModel,
  ) {
    if (viewModel.progression.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                "No hay resultados de carrera esta temporada.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final spots = viewModel.progression.map((p) {
      double yValue = p.isDNF ? 0 : 25 - p.position.toDouble();
      return FlSpot(p.round.toDouble(), yValue);
    }).toList();

    return AspectRatio(
      aspectRatio: 1.4,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 8, top: 16, bottom: 8),
        child: LineChart(
          LineChartData(
            minX: 1,
            maxX: viewModel.progression.last.round.toDouble(),
            minY: 0,
            maxY: 25,
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  interval: 5,
                  getTitlesWidget: (value, meta) {
                    final position = 25 - value.toInt();
                    if (position >= 1 && position <= 20) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          'P$position',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 2,
                  getTitlesWidget: (value, meta) {
                    if (value % 1 != 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'R${value.toInt()}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                color: theme.colorScheme.primary,
                barWidth: 3.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    final isDNF = spot.y <= 0;
                    return FlDotCirclePainter(
                      radius: isDNF ? 6 : 4,
                      color: isDNF
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      strokeWidth: isDNF ? 2.5 : 0,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.2),
                      theme.colorScheme.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (spot) => theme.colorScheme.surface,
                tooltipBorder: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                tooltipPadding: const EdgeInsets.all(12),
                getTooltipItems: (touchedSpots) {
                  if (touchedSpots.isEmpty) return [];

                  return touchedSpots.map((spot) {
                    final data = viewModel.progression[spot.spotIndex];
                    final position = 25 - spot.y.toInt();
                    final translatedStatus = StatusTranslator.translate(
                      data.status,
                    );

                    String titleText;
                    Color titleColor;

                    if (data.isDNF) {
                      titleText = data.status == 'Disqualified'
                          ? 'DSQ'
                          : 'DNF: $translatedStatus';
                      titleColor = theme.colorScheme.error;
                    } else {
                      titleText = 'P$position';
                      titleColor = theme.colorScheme.primary;
                    }

                    return LineTooltipItem(
                      '$titleText\n',
                      TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '${RaceNameTranslator.translate(data.raceName)}\n',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'Ronda ${data.round}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentResultsSection(
    ThemeData theme,
    DriverDetailViewModel viewModel,
  ) {
    if (viewModel.isLoading || viewModel.progression.isEmpty) {
      return const SizedBox.shrink();
    }

    final recentResults = viewModel.progression.reversed.take(5).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.history,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Últimos Resultados",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recentResults.map((result) {
              final isDNF = result.isDNF;
              final positionColor = result.position == 1
                  ? const Color(0xFFFFD700)
                  : result.position == 2
                  ? const Color(0xFFC0C0C0)
                  : result.position == 3
                  ? const Color(0xFFCD7F32)
                  : theme.colorScheme.primary.withValues(alpha: 0.2);

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDNF
                      ? theme.colorScheme.error.withValues(alpha: 0.05)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDNF
                        ? theme.colorScheme.error.withValues(alpha: 0.3)
                        : theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDNF ? theme.colorScheme.error : positionColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          isDNF ? 'DNF' : 'P${result.position}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isDNF ? 10 : 14,
                            color: result.position <= 3 && !isDNF
                                ? Colors.white
                                : isDNF
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            RaceNameTranslator.translate(result.raceName),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isDNF) ...[
                            const SizedBox(height: 2),
                            Text(
                              StatusTranslator.translate(result.status),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'R${result.round}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
