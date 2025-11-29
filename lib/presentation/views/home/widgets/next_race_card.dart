import 'package:f1_fanhub/core/utils/circuit_name_translator.dart';
import 'package:f1_fanhub/core/utils/date_formatter.dart';
import 'package:f1_fanhub/core/utils/flags_helper.dart';
import 'package:f1_fanhub/core/utils/race_name_translator.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:flutter/material.dart';

class NextRaceCard extends StatelessWidget {
  final Race race;

  const NextRaceCard({super.key, required this.race});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12), // ← Agregar
      child: InkWell(
        onTap: () => _showRaceDetailsDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'PRÓXIMO GRAN PREMIO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Bandera
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        FlagHelper.getFlagPath(race.country),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          RaceNameTranslator.translate(race.raceName),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                DateFormatter.formatSessionDateTime(
                                  race.date,
                                  race.time,
                                ),
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                CircuitNameTranslator.translate(
                                  race.circuitName,
                                ),
                                style: theme.textTheme.bodySmall,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer - Indicador de tap
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ver horarios del fin de semana',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRaceDetailsDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width, // Ocupa todo el ancho
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header del diálogo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  FlagHelper.getFlagPath(race.country),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    RaceNameTranslator.translate(race.raceName),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    CircuitNameTranslator.translate(
                                      race.circuitName,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contenido del diálogo
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Horarios del Fin de Semana",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._buildSessionList(theme),
                      ],
                    ),
                  ),

                  // Botón de cierre
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cerrar",
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSessionList(ThemeData theme) {
    List<Widget> sessionWidgets = [];

    Widget buildRow(
      String label,
      Map<String, String>? session, {
      bool isMain = false,
      IconData? icon,
    }) {
      if (session == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMain
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isMain
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.outline.withValues(alpha: 0.2),
            width: isMain ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isMain
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isMain ? FontWeight.bold : FontWeight.w500,
                  fontSize: isMain ? 15 : 14,
                  color: isMain ? theme.colorScheme.primary : null,
                ),
              ),
            ),
            Text(
              DateFormatter.formatSessionDateTime(
                session['date']!,
                session['time']!,
              ),
              style: TextStyle(
                fontSize: 13,
                fontWeight: isMain ? FontWeight.bold : FontWeight.w500,
                color: isMain ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      );
    }

    // Práctica 1
    sessionWidgets.add(
      buildRow("Práctica 1", race.firstPractice, icon: Icons.speed),
    );

    // Sprint vs Normal
    if (race.isSprintWeekend) {
      sessionWidgets.add(
        buildRow(
          "Clasificación Sprint",
          race.sprintQualifying,
          icon: Icons.timer,
        ),
      );
      sessionWidgets.add(buildRow("Sprint", race.sprint, icon: Icons.flash_on));
    } else {
      sessionWidgets.add(
        buildRow("Práctica 2", race.secondPractice, icon: Icons.speed),
      );
      sessionWidgets.add(
        buildRow("Práctica 3", race.thirdPractice, icon: Icons.speed),
      );
    }

    // Clasificación
    sessionWidgets.add(
      buildRow("Clasificación", race.qualifying, icon: Icons.timer),
    );

    sessionWidgets.add(const SizedBox(height: 8));

    // Carrera principal
    sessionWidgets.add(
      buildRow(
        "CARRERA",
        {'date': race.date, 'time': race.time},
        isMain: true,
        icon: Icons.emoji_events,
      ),
    );

    return sessionWidgets;
  }
}
