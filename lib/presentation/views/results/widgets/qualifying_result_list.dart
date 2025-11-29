import 'package:f1_fanhub/core/utils/image_helper.dart';
import 'package:f1_fanhub/domain/entities/qualifying_result.dart';
import 'package:flutter/material.dart';

class QualifyingResultList extends StatelessWidget {
  final List<QualifyingResult> results;

  const QualifyingResultList({super.key, required this.results});

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
              "Resultados de clasificación no disponibles.",
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header mejorado
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 35,
                child: Text(
                  "Pos",
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 46), // Espacio foto
              SizedBox(
                width: 50,
                child: Text(
                  "Piloto",
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Q1",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Q2",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Q3",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Lista de resultados
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              final isTop10 = index < 10;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                elevation: isTop10 ? 2 : 1,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // Posición
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: isTop10
                              ? theme.colorScheme.primary.withValues(
                                  alpha: 0.15,
                                )
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isTop10
                                ? theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  )
                                : theme.colorScheme.outline.withValues(
                                    alpha: 0.2,
                                  ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            result.position,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isTop10
                                  ? theme.colorScheme.primary
                                  : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Foto pequeña
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            ImageHelper.getDriverImage(result.driver.id),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Código del piloto
                      SizedBox(
                        width: 50,
                        child: Text(
                          result.driver.code.isNotEmpty
                              ? result.driver.code
                              : result.driver.familyName
                                    .substring(0, 3)
                                    .toUpperCase(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Tiempos
                      Expanded(child: _buildTimeCell(theme, result.q1, false)),
                      Expanded(child: _buildTimeCell(theme, result.q2, false)),
                      Expanded(child: _buildTimeCell(theme, result.q3, true)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCell(ThemeData theme, String? time, bool isQ3) {
    if (time == null || time.isEmpty) {
      return Center(
        child: Text(
          "-",
          style: TextStyle(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: isQ3
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isQ3 ? FontWeight.bold : FontWeight.w500,
            color: isQ3
                ? theme.colorScheme.primary
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}
