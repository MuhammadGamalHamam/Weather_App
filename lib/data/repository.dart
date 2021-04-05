import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/weather_model.dart';

class Repository {
  Future<WeatherModel> getWeather(String city) async {
    print("Getting weather for: $city\n");
    final result = await http.Client().get(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=296f787d9e285f182d44176519b00094&units=metric&lang=pt");

    if (result.statusCode == 404)
      throw Exception("City Not Found.");
    else if (result.statusCode != 200) throw Exception();

    return parsedJson(city, result.body);
  }

  WeatherModel parsedJson(final name, final response) {
    final jsonDecoded = json.decode(response);
    return WeatherModel.fromJson(jsonDecoded);
  }
}
