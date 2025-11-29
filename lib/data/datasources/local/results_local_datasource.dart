import 'dart:convert';
import 'package:f1_fanhub/core/errors/exceptions.dart';
import 'package:f1_fanhub/data/models/pit_stop_model.dart';
import 'package:f1_fanhub/data/models/qualifying_result_model.dart';
import 'package:f1_fanhub/data/models/race_result_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsLocalDataSource {
  final SharedPreferences sharedPreferences;

  ResultsLocalDataSource(this.sharedPreferences);

  // --- CARRERA ---
  Future<void> cacheRaceResults(String round, List<RaceResultModel> results) {
    final jsonList = results.map((e) => e.toJson()).toList();
    // Key dinámica: "RACE_RESULT_1", "RACE_RESULT_2", etc.
    return sharedPreferences.setString(
      'RACE_RESULT_$round',
      json.encode(jsonList),
    );
  }

  Future<List<RaceResultModel>> getRaceResults(String round) {
    final jsonString = sharedPreferences.getString('RACE_RESULT_$round');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((e) => RaceResultModel.fromJson(e)).toList(),
      );
    } else {
      throw CacheException();
    }
  }

  // --- CLASIFICACIÓN ---
  Future<void> cacheQualifyingResults(
    String round,
    List<QualifyingResultModel> results,
  ) {
    final jsonList = results.map((e) => e.toJson()).toList();
    return sharedPreferences.setString(
      'QUALY_RESULT_$round',
      json.encode(jsonList),
    );
  }

  Future<List<QualifyingResultModel>> getQualifyingResults(String round) {
    final jsonString = sharedPreferences.getString('QUALY_RESULT_$round');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((e) => QualifyingResultModel.fromJson(e)).toList(),
      );
    } else {
      throw CacheException();
    }
  }

  // --- SPRINT ---
  Future<void> cacheSprintResults(String round, List<RaceResultModel> results) {
    final jsonList = results.map((e) => e.toJson()).toList();
    return sharedPreferences.setString(
      'SPRINT_RESULT_$round',
      json.encode(jsonList),
    );
  }

  Future<List<RaceResultModel>> getSprintResults(String round) {
    final jsonString = sharedPreferences.getString('SPRINT_RESULT_$round');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((e) => RaceResultModel.fromJson(e)).toList(),
      );
    } else {
      throw CacheException();
    }
  }

  // --- PIT STOPS ---
  Future<void> cachePitStops(String round, List<PitStopModel> pitStops) {
    final jsonList = pitStops.map((e) => e.toJson()).toList();
    // Key dinámica: "PIT_STOPS_1", "PIT_STOPS_5", etc.
    return sharedPreferences.setString(
      'PIT_STOPS_$round',
      json.encode(jsonList),
    );
  }

  Future<List<PitStopModel>> getPitStops(String round) {
    final jsonString = sharedPreferences.getString('PIT_STOPS_$round');

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((e) => PitStopModel.fromJson(e)).toList(),
      );
    } else {
      throw CacheException();
    }
  }
}
