import 'package:intl/intl.dart';

class DateFormatter {
  // Convierte "2024-11-28" y "14:30:00Z" a "28 nov, 8:30 a. m." (Hora local)
  static String formatSessionDateTime(String date, String time) {
    if (date.isEmpty || time.isEmpty) return "TBC";

    try {
      // La API devuelve UTC (Z), así que parseamos como UTC
      // A veces la hora viene como "14:00:00Z" y a veces sin Z.
      String cleanTime = time.endsWith('Z') ? time : '${time}Z';
      DateTime utcDate = DateTime.parse('${date}T$cleanTime');

      // Convertimos a hora local del teléfono del usuario
      DateTime localDate = utcDate.toLocal();

      // Formateamos: "28 nov, 7:30 a. m."
      // Asegúrate de tener: initializeDateFormatting('es'); en tu main si quieres español
      return DateFormat("d MMM, h:mm a", 'es_ES').format(localDate);
    } catch (e) {
      return "$date $time";
    }
  }

  // Para el rango de fechas del encabezado "28 - 30 de noviembre"
  static String formatRaceDateRange(String raceDate) {
    try {
      DateTime end = DateTime.parse(raceDate);
      DateTime start = end.subtract(const Duration(days: 2));
      return "${DateFormat("d").format(start)} - ${DateFormat("d 'de' MMMM", 'es_ES').format(end)}";
    } catch (e) {
      return raceDate;
    }
  }
}
