import 'package:f1_fanhub/core/utils/circuit_name_translator.dart';
import 'package:f1_fanhub/core/utils/flags_helper.dart';
import 'package:f1_fanhub/core/utils/image_helper.dart';
import 'package:f1_fanhub/core/utils/race_name_translator.dart';
import 'package:f1_fanhub/domain/entities/race.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:f1_fanhub/presentation/views/results/race_results_screen.dart';
import 'package:flutter/material.dart';

class LastRaceCard extends StatelessWidget {
  final Race race;
  final RaceResult? winner;

  const LastRaceCard({super.key, required this.race, this.winner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12), // ← Agregar
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RaceResultsScreen(round: race.id, raceName: race.raceName),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con gradiente sutil
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.15),
                    theme.colorScheme.secondary.withValues(alpha: 0.15),
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
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.emoji_events_rounded,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'ÚLTIMA CARRERA',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (winner != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700), // Oro
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'P1',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de la carrera
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
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
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              CircuitNameTranslator.translate(race.circuitName),
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (winner != null) ...[
                    const SizedBox(height: 16),

                    // Sección del ganador
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.1),
                            theme.colorScheme.secondary.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Foto del piloto
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(
                                  ImageHelper.getDriverImage(winner!.driver.id),
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Info del ganador
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD700),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'GANADOR',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${winner!.driver.givenName} ${winner!.driver.familyName}",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
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
                                          winner!.constructor.id,
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        winner!.constructor.name,
                                        style: theme.textTheme.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Icono de flecha
                          Icon(
                            Icons.chevron_right_rounded,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
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
                    'Ver resultados completos',
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
}
