import 'package:f1_fanhub/core/utils/image_helper.dart';
import 'package:f1_fanhub/domain/entities/race_result.dart';
import 'package:flutter/material.dart';

class RaceResultList extends StatelessWidget {
  final List<RaceResult> results;

  const RaceResultList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "Resultados no disponibles aún.",
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final isPodium = index < 3;
        final isFastestLap = result.fastestLapRank == "1";

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isPodium ? 3 : 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isPodium
                  ? LinearGradient(
                      colors: [
                        _getPodiumColor(index).withValues(alpha: 0.1),
                        theme.colorScheme.surface,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // 1. POSICIÓN con medalla para podio
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isPodium
                          ? _getPodiumColor(index)
                          : theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isPodium
                          ? [
                              BoxShadow(
                                color: _getPodiumColor(
                                  index,
                                ).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        result.position,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isPodium
                              ? Colors.white
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. FOTO PILOTO
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isPodium
                            ? _getPodiumColor(index)
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImageHelper.getDriverImage(result.driver.id),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 3. NOMBRE Y EQUIPO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${result.driver.givenName} ${result.driver.familyName}",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.asset(
                                ImageHelper.getConstructorLogo(
                                  result.constructor.id,
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                result.constructor.name,
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 4. TIEMPO, PUNTOS Y VUELTA RÁPIDA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // A) Tiempo de Carrera o Estado
                      Text(
                        result.timeOrStatus,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      // B) Vuelta Rápida
                      if (isFastestLap && result.fastestLapTime != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.purple.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.flash_on,
                                size: 12,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                result.fastestLapTime!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // C) Puntos
                      if (result.points != "0") ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            "+${result.points}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPodiumColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Oro
      case 1:
        return const Color(0xFFC0C0C0); // Plata
      case 2:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return Colors.grey;
    }
  }
}
