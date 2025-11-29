import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:f1_fanhub/data/models/race_model.dart';
import 'package:f1_fanhub/core/errors/exceptions.dart';

const cachedRaces = 'CACHED_RACES';
const cachedRacesTimestamp = 'CACHED_RACES_TIMESTAMP';

class RaceLocalDataSource {
  final SharedPreferences sharedPreferences;

  RaceLocalDataSource(this.sharedPreferences);

  Future<void> cacheRaces(List<RaceModel> races) {
    // 1. Convertimos la lista de objetos a una lista de JSONs
    final List<Map<String, dynamic>> jsonList = races
        .map((race) => race.toJson())
        .toList();
    // 2. Guardamos el String y la fecha actual
    sharedPreferences.setString(cachedRaces, json.encode(jsonList));
    sharedPreferences.setInt(
      cachedRacesTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
    return Future.value();
  }

  Future<List<RaceModel>> getLastRaces() {
    final jsonString = sharedPreferences.getString(cachedRaces);

    if (jsonString != null) {
      // Convertimos el String de vuelta a objetos
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((json) => RaceModel.fromJson(json)).toList(),
      );
    } else {
      // 2. Aquí lanzamos la excepción específica en lugar de una genérica
      throw CacheException();
    }
  }

  // Verifica si el caché es válido 7 dias)
  bool isCacheValid() {
    final timestamp = sharedPreferences.getInt(cachedRacesTimestamp);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    final differenceInDays = now.difference(cachedTime).inDays;

    return differenceInDays < 7; // El caché dura 1 semana
  }
}
