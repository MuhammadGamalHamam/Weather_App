part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeatherEvent extends WeatherEvent {
  final String cityName;
  FetchWeatherEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class ResetWeatherEvent extends WeatherEvent {}

class LoadFromDbEvent extends WeatherEvent {}

class SaveWeatherEvent extends WeatherEvent {
  final _weather;

  SaveWeatherEvent(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}

class RefreshCityListEvent extends WeatherEvent {}

class OpenSelectedWeatherScreenEvent extends WeatherEvent {
  final _weather;

  OpenSelectedWeatherScreenEvent(this._weather);

  WeatherModel get getWeather => _weather;

  @override
  List<Object> get props => [_weather];
}
