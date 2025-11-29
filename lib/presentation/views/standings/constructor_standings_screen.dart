import 'package:f1_fanhub/core/utils/flags_helper.dart';
import 'package:f1_fanhub/core/utils/image_helper.dart';
import 'package:f1_fanhub/core/utils/nationality_translator.dart';
import 'package:f1_fanhub/presentation/viewmodels/constructor_standings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConstructorStandingsScreen extends StatefulWidget {
  const ConstructorStandingsScreen({super.key});

  @override
  State<ConstructorStandingsScreen> createState() =>
      _ConstructorStandingsScreenState();
}

class _ConstructorStandingsScreenState
    extends State<ConstructorStandingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConstructorStandingsViewModel>().loadStandings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ConstructorStandingsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Campeonato de Constructores',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: _buildBody(viewModel, theme),
    );
  }

  Widget _buildBody(ConstructorStandingsViewModel viewModel, ThemeData theme) {
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

    // Calcular máximo de puntos
    final maxPoints = viewModel.constructors.isNotEmpty
        ? double.parse(viewModel.constructors.first.points)
        : 100.0;

    return RefreshIndicator(
      color: theme.colorScheme.primary,
      onRefresh: () async => await viewModel.refreshStandings(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        itemCount: viewModel.constructors.length,
        itemBuilder: (context, index) {
          final standing = viewModel.constructors[index];
          final isTop3 = index < 3;
          final points = double.parse(standing.points);
          final percentage = maxPoints > 0 ? points / maxPoints : 0.0;

          return Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // POSICIÓN con diseño de medalla
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

                      // LOGO DEL CONSTRUCTOR con fondo
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.05,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.2,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          ImageHelper.getConstructorLogo(
                            standing.constructor.id,
                          ),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.shield_outlined,
                              color: theme.colorScheme.primary,
                              size: 32,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),

                      // INFO DEL CONSTRUCTOR
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              standing.constructor.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            // Nacionalidad
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                      color: theme.colorScheme.outline
                                          .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: Image.asset(
                                      FlagHelper.getFlagPath(
                                        standing.constructor.nationality,
                                      ),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    NationalityTranslator.translate(
                                      standing.constructor.nationality,
                                    ),
                                    style: theme.textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // PUNTOS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
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
