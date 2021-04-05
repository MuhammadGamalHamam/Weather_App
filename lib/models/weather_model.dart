import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class WeatherModel extends Equatable {
  final int id;
  final String cityName;
  final double temp;
  final double tempMax;
  final double tempMin;
  final String description;
  final String icon;
  final int lastUpdate;

  double get getTemp => temp;
  double get getMaxTemp => tempMax;
  double get getMinTemp => tempMin;
  String get getCityName => cityName;
  String get getLastUpdate => DateFormat("dd/MM/yyyy HH:mm:ss")
      .format(DateTime.fromMillisecondsSinceEpoch(lastUpdate));
  WeatherModel(this.id, this.cityName, this.temp, this.tempMax, this.tempMin,
      this.description, this.icon, this.lastUpdate);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        json["id"],
        json["name"],
        json["main"]["temp"].toDouble(),
        json["main"]["temp_max"].toDouble(),
        json["main"]["temp_min"].toDouble(),
        json["weather"][0]["description"],
        json["weather"][0]["icon"],
        DateTime.now().millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cityName': cityName,
      'temp': temp,
      'tempMax': tempMax,
      'tempMin': tempMin,
      'description': description,
      'icon': icon,
      'lastUpdate': lastUpdate
    };
  }

  @override
  List<Object> get props => [cityName];
}
