import 'package:f1_fanhub/core/utils/circuit_name_translator.dart';
import 'package:f1_fanhub/core/utils/race_name_translator.dart';
import 'package:f1_fanhub/presentation/views/results/race_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/core/utils/date_formatter.dart';
import 'package:f1_fanhub/core/utils/flags_helper.dart';

class RaceCard extends StatelessWidget {
  final Race race;
  final bool isExpanded;
  final VoidCallback onTap;

  const RaceCard({
    super.key,
    required this.race,
    required this.isExpanded,
    required this.onTap,
  });

  // Lógica para saber si la carrera ya pasó
  bool get _isRaceFinished {
    try {
      final now = DateTime.now();
      final raceDate = DateTime.parse(race.date).add(const Duration(hours: 4));
      return now.isAfter(raceDate);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String country = race.country;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isExpanded ? 4 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isExpanded
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header con gradiente si está expandido
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isExpanded
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                          theme.colorScheme.secondary.withValues(alpha: 0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                border: isExpanded
                    ? Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          width: 2,
                        ),
                      )
                    : null,
              ),
              child: _buildHeader(context, country),
            ),

            // Contenido expandible
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSessionList(context),
                          if (_isRaceFinished) ...[
                            const SizedBox(height: 16),
                            _buildResultsButton(context),
                          ],
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String country) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Bandera con borde decorativo
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: isExpanded
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: Image.asset(
              FlagHelper.getFlagPath(country),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.flag, color: theme.colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Información principal
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la carrera
              Text(
                RaceNameTranslator.translate(race.raceName),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Circuito y ronda
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'R${race.id}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      CircuitNameTranslator.translate(race.circuitName),
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Indicador de Sprint si aplica
              if (race.isSprintWeekend) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.flash_on,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'SEMANA DE SPRINT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Fecha y flecha
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Badge de fecha
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isExpanded
                    ? [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                DateFormatter.formatRaceDateRange(race.date),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Icono de estado de carrera
            if (_isRaceFinished)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              )
            else
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionList(BuildContext context) {
    Theme.of(context);
    List<Widget> sessionWidgets = [];

    // Práctica 1
    if (race.firstPractice != null) {
      sessionWidgets.add(
        _buildSessionRow(
          context,
          "Práctica 1",
          race.firstPractice!,
          Icons.speed,
        ),
      );
    }

    if (race.isSprintWeekend) {
      // Sprint Qualifying
      if (race.sprintQualifying != null) {
        sessionWidgets.add(
          _buildSessionRow(
            context,
            "Clasificación Sprint",
            race.sprintQualifying!,
            Icons.timer,
          ),
        );
      }
      // Sprint
      if (race.sprint != null) {
        sessionWidgets.add(
          _buildSessionRow(
            context,
            "Sprint",
            race.sprint!,
            Icons.flash_on,
            isHighlight: true,
          ),
        );
      }
    } else {
      // Práctica 2
      if (race.secondPractice != null) {
        sessionWidgets.add(
          _buildSessionRow(
            context,
            "Práctica 2",
            race.secondPractice!,
            Icons.speed,
          ),
        );
      }
      // Práctica 3
      if (race.thirdPractice != null) {
        sessionWidgets.add(
          _buildSessionRow(
            context,
            "Práctica 3",
            race.thirdPractice!,
            Icons.speed,
          ),
        );
      }
    }

    // Clasificación
    if (race.qualifying != null) {
      sessionWidgets.add(
        _buildSessionRow(
          context,
          "Clasificación",
          race.qualifying!,
          Icons.timer,
        ),
      );
    }

    // Carrera principal
    sessionWidgets.add(
      _buildSessionRow(
        context,
        "CARRERA",
        {'date': race.date, 'time': race.time},
        Icons.emoji_events,
        isMainEvent: true,
      ),
    );

    return Column(
      children: sessionWidgets
          .map(
            (widget) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: widget,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSessionRow(
    BuildContext context,
    String title,
    Map<String, String> sessionData,
    IconData icon, {
    bool isMainEvent = false,
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);
    final formattedTime = DateFormatter.formatSessionDateTime(
      sessionData['date']!,
      sessionData['time']!,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMainEvent
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isMainEvent
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.1),
          width: isMainEvent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icono
          Icon(
            icon,
            size: 18,
            color: isMainEvent
                ? theme.colorScheme.primary
                : isHighlight
                ? theme.colorScheme.secondary
                : theme.iconTheme.color?.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),

          // Título
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isMainEvent ? 14 : 13,
                fontWeight: isMainEvent || isHighlight
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: isMainEvent
                    ? theme.colorScheme.primary
                    : isHighlight
                    ? theme.colorScheme.secondary
                    : null,
              ),
            ),
          ),

          // Hora
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isMainEvent
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              formattedTime,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isMainEvent ? FontWeight.bold : FontWeight.w500,
                color: isMainEvent ? theme.colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsButton(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RaceResultsScreen(round: race.id, raceName: race.raceName),
            ),
          );
        },
        icon: const Icon(Icons.emoji_events, size: 22),
        label: const Text(
          "VER RESULTADOS COMPLETOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
