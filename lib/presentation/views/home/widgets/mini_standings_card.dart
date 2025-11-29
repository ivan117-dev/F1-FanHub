import 'package:flutter/material.dart';

class MiniStandingsCard extends StatelessWidget {
  final String title;
  final List<dynamic> items; // Acepta DriverStanding o ConstructorStanding
  final bool isDriver; // Para saber qué campos mostrar
  final VoidCallback onTapMore;

  const MiniStandingsCard({
    super.key,
    required this.title,
    required this.items,
    required this.isDriver,
    required this.onTapMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calcular el máximo de puntos para la barra de progreso
    final maxPoints = items.isNotEmpty
        ? double.parse(items.first.points)
        : 100.0;

    return Expanded(
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero, // Asegúrate de que no haya margen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12), // ← Mantener en 12
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.15),
                    theme.colorScheme.secondary.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isDriver ? Icons.sports_motorsports : Icons.build,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Lista TOP 5
            Padding(
              padding: const EdgeInsets.all(12), // ← Mantener en 12
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    String name = "";
                    String points = "";

                    if (isDriver) {
                      name = item.driver.familyName;
                      points = item.points;
                    } else {
                      name = item.constructor.name;
                      points = item.points;
                    }

                    final pointsValue = double.parse(points);
                    final percentage = maxPoints > 0
                        ? pointsValue / maxPoints
                        : 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // Posición con estilo de medalla para top 3
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: _getPositionColor(theme, index + 1),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: index < 3
                                      ? [
                                          BoxShadow(
                                            color: _getPositionColor(
                                              theme,
                                              index + 1,
                                            ).withValues(alpha: 0.4),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                      color: index < 3
                                          ? Colors.white
                                          : theme.colorScheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Nombre
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: index < 3
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 4),

                              // Puntos
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  points,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Barra de progreso
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: percentage,
                              minHeight: 4,
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation(
                                index < 3
                                    ? _getPositionColor(theme, index + 1)
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Botón VER MÁS mejorado
                  InkWell(
                    onTap: onTapMore,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "Ver completa",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
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
