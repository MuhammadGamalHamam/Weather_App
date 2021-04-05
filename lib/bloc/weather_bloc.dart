import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:weather_app/data/repository.dart';
import 'package:weather_app/db/database.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:equatable/equatable.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  Repository weatherRepo;
  Set<WeatherModel> weatherList = Set<WeatherModel>();

  WeatherBloc(this.weatherRepo) : super(null) {
    this.add(LoadFromDbEvent());
  }

  DatabaseProvider db = DatabaseProvider.db;

  List<WeatherModel> get getWeatherList =>
      weatherList.toList()..sort((a, b) => a.cityName.compareTo(b.cityName));

  WeatherState get initialState => WeatherIsLoadingState();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeatherEvent) {
      yield WeatherIsLoadingState();
      try {
        WeatherModel weather = await weatherRepo.getWeather(event.cityName);
        yield OpenSelectedWeatherScreenState(weather);
      } on Exception catch (e) {
        yield WeatherIsNotLoadedState(
            e.toString().replaceFirst("Exception: ", ""));
      } catch (_) {
        yield WeatherIsNotLoadedState("Erro Desconhecido");
      }
    } else if (event is ResetWeatherEvent) {
      yield WeatherIsNotSearchedState();
    } else if (event is SaveWeatherEvent) {
      db.addWeather(event.getWeather);
      this.weatherList.add(event.getWeather);
      yield WeatherIsNotSearchedState();
    } else if (event is LoadFromDbEvent) {
      await this._getCityListFromDb();
      await this._updateAsync();
      yield WeatherIsNotSearchedState();
    } else if (event is RefreshCityListEvent) {
      yield WeatherIsLoadingState();
      await this._updateAsync();
      yield WeatherIsNotSearchedState();
    } else if (event is OpenSelectedWeatherScreenEvent) {
      yield OpenSelectedWeatherScreenState(event.getWeather);
    }
  }

  Future<void> _getCityListFromDb() async {
    var list = await db.getAllWeather();
    this.weatherList.addAll(list);
  }

  Future<void> _updateAsync() async {
    List<WeatherModel> updatedList = <WeatherModel>[];
    await Future.forEach(getWeatherList, (element) async {
      WeatherModel updatedWeather =
          await weatherRepo.getWeather(element.cityName);
      updatedList.add(updatedWeather);
      db.addWeather(updatedWeather);
    });
    this.weatherList.clear();
    this.weatherList.addAll(updatedList);
  }
}
