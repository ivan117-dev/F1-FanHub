import 'package:f1_fanhub/presentation/viewmodels/theme_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Función auxiliar para abrir links
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Si falla, podrías mostrar un SnackBar
      debugPrint('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          _buildSectionHeader("APARIENCIA"),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text("Modo Oscuro"),
            subtitle: const Text("Cambiar tema de la aplicación"),
            trailing: Switch(
              value: context
                  .watch<ThemeViewModel>()
                  .isDarkMode, // Usamos el valor real del ViewModel
              activeThumbColor: const Color(0xFF69C56C), // Tu verde
              onChanged: (val) {
                // Llamamos al método para cambiar el tema
                context.read<ThemeViewModel>().toggleTheme(val);
              },
            ),
          ),

          const Divider(),

          _buildSectionHeader("ACERCA DE"),

          // 1. CRÉDITOS DEL DESARROLLADOR (Usa el Dialog Nativo)
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text("Desarrollador"),
            subtitle: const Text("Ver créditos y licencias"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'F1 FanHub',
                applicationVersion: '1.0.0',
                applicationIcon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sports_motorsports),
                ),
                applicationLegalese:
                    '© 2025 CHRISTIAN MARTINEZ\nHecho con Flutter & Clean Architecture.',
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Esta aplicación es un proyecto de demostración para la materia de Desarrollo de Aplicaciones Híbridas y no está afiliada a la Formula 1 companies.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              );
            },
          ),

          // 2. FUENTE DE DATOS (Abre el navegador)
          ListTile(
            leading: const Icon(Icons.data_usage),
            title: const Text("Fuente de Datos"),
            subtitle: const Text("Powered by Jolpica & Ergast API"),
            trailing: const Icon(
              Icons.open_in_new,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              _launchUrl('https://github.com/jolpica/jolpica-f1');
            },
          ),

          // 3. VERSIÓN
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Versión"),
            trailing: const Text("1.0.0", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
