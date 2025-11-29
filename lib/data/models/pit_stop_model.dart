import 'package:f1_fanhub/domain/entities/pit_stop.dart';

class PitStopModel extends PitStop {
  PitStopModel({
    required super.driverId,
    required super.lap,
    required super.stop,
    required super.time,
    required super.duration,
  });

  factory PitStopModel.fromJson(Map<String, dynamic> json) {
    return PitStopModel(
      driverId: json['driverId'],
      lap: json['lap'],
      stop: json['stop'],
      time: json['time'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'lap': lap,
      'stop': stop,
      'time': time,
      'duration': duration,
    };
  }
}
