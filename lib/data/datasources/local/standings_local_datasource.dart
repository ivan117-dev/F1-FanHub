import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:f1_fanhub/core/errors/exceptions.dart';
import 'package:f1_fanhub/data/models/standing_model.dart';

const cachedDrivers = 'CACHED_DRIVERS';
const cachedConstructors = 'CACHED_CONSTRUCTORS';
const driversTimestamp = 'DRIVERS_TIMESTAMP';
const constructorsTimestamp = 'CONSTRUCTORS_TIMESTAMP';

class StandingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  StandingsLocalDataSource(this.sharedPreferences);

  // --- DRIVERS ---
  Future<void> cacheDriverStandings(List<DriverStandingModel> standings) {
    final jsonList = standings.map((e) => e.toJson()).toList();
    sharedPreferences.setString(cachedDrivers, json.encode(jsonList));
    sharedPreferences.setInt(
      driversTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
    return Future.value();
  }

  Future<List<DriverStandingModel>> getLastDriverStandings() {
    final jsonString = sharedPreferences.getString(cachedDrivers);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((j) => DriverStandingModel.fromJson(j)).toList(),
      );
    } else {
      throw CacheException();
    }
  }

  // --- CONSTRUCTORS ---
  Future<void> cacheConstructorStandings(
    List<ConstructorStandingModel> standings,
  ) {
    final jsonList = standings.map((e) => e.toJson()).toList();
    sharedPreferences.setString(cachedConstructors, json.encode(jsonList));
    sharedPreferences.setInt(
      constructorsTimestamp,
      DateTime.now().millisecondsSinceEpoch,
    );
    return Future.value();
  }

  Future<List<ConstructorStandingModel>> getLastConstructorStandings() {
    final jsonString = sharedPreferences.getString(cachedConstructors);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((j) => ConstructorStandingModel.fromJson(j)).toList(),
      );
    } else {
      throw CacheException();
    }
  }

  // --- LÓGICA INTELIGENTE DE CACHÉ ---
  bool isCacheValid(String timestampKey) {
    final timestamp = sharedPreferences.getInt(timestampKey);
    if (timestamp == null) return false;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cachedTime);

    // Verificamos si hoy es fin de semana (Sábado=6, Domingo=7)
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    if (isWeekend) {
      // Fin de semana: El caché expira cada 4 horas (carreras/sprints cambian puntos)
      return difference.inHours < 4;
    } else {
      // Entre semana: El caché expira cada 5 días entre semana
      final differenceInDays = now.difference(cachedTime).inDays;
      return differenceInDays < 5;
    }
  }
}
