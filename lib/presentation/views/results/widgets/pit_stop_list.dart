import 'package:f1_fanhub/core/utils/image_helper.dart';
import 'package:f1_fanhub/domain/entities/pit_stop.dart';
import 'package:flutter/material.dart';

class PitStopList extends StatelessWidget {
  final List<PitStop> pitStops;

  const PitStopList({super.key, required this.pitStops});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (pitStops.isEmpty) {
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
            Text("No hay datos de paradas.", style: theme.textTheme.bodyLarge),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header mejorado
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                width: 50,
                child: Text(
                  "Piloto",
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    "Vuelta",
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    "Stop",
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 90,
                child: Center(
                  child: Text(
                    "Duración",
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Lista de pit stops
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: pitStops.length,
            itemBuilder: (context, index) {
              final stop = pitStops[index];
              final durationText = stop.duration;

              // Intentar parsear duración para destacar paradas rápidas
              double? durationSeconds;
              try {
                durationSeconds = double.parse(durationText);
              } catch (e) {
                durationSeconds = null;
              }

              final isFastStop =
                  durationSeconds != null && durationSeconds < 3.0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                elevation: isFastStop ? 3 : 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isFastStop
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withValues(alpha: 0.1),
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
                        // Foto del piloto
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFastStop
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline.withValues(
                                      alpha: 0.3,
                                    ),
                              width: 2,
                            ),
                            boxShadow: isFastStop
                                ? [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              ImageHelper.getDriverImage(stop.driverId),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Nombre del piloto
                        Expanded(
                          child: Text(
                            _formatDriverName(stop.driverId),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Vuelta
                        SizedBox(
                          width: 50,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                stop.lap,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Número de parada
                        SizedBox(
                          width: 50,
                          child: Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                ),
                                shape: BoxShape.circle,
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
                              child: Center(
                                child: Text(
                                  stop.stop,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Duración
                        SizedBox(
                          width: 90,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isFastStop
                                    ? theme.colorScheme.primary.withValues(
                                        alpha: 0.2,
                                      )
                                    : theme.colorScheme.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isFastStop
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                  width: isFastStop ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isFastStop)
                                    Icon(
                                      Icons.flash_on,
                                      size: 14,
                                      color: theme.colorScheme.primary,
                                    ),
                                  if (isFastStop) const SizedBox(width: 3),
                                  Text(
                                    "${durationText}s",
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: isFastStop
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDriverName(String driverId) {
    // Convertir de formato snake_case a nombre legible
    return driverId
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
