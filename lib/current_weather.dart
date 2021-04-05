import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bloc/weather_bloc.dart';
import 'models/weather_model.dart';

class ScreenArguments {
  final WeatherModel weather;
  ScreenArguments(this.weather);
}

class CurrentWeatherScreen extends StatelessWidget {
  static const routeName = '/currentWeatherScreen';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Center(
        child: Container(
            child: Stack(
          children: [
            Container(
              child: FlareActor(
                "assets/background.flr",
                fit: BoxFit.fill,
                animation: "0",
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Current Weather App',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context, ResetWeatherEvent());
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: CurrentWeatherWidget(args.weather),
            ),
          ],
        )),
      ),
    );
  }
}

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherModel weatherModel;

  CurrentWeatherWidget(this.weatherModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: FlareActor(
                  "assets/weather_${weatherModel.icon}.flr",
                  animation: "${weatherModel.icon}",
                ),
                height: 150,
                width: 300,
              ),
              Text(
                weatherModel.getCityName,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                  "${weatherModel.description[0].toUpperCase() + weatherModel.description.substring(1)}",
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Text(
                "${weatherModel.temp.round().toInt()} C",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Temperature",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "${weatherModel.getMaxTemp.round().toInt()} C",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Temperature Maximum",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "${weatherModel.getMinTemp.round().toInt()} C",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Temperature Minimum",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, SaveWeatherEvent(weatherModel));
                  },
                  child: Text("Favorite",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.lightGreen),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30)))),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, ResetWeatherEvent());
                  },
                  child: Text("Back",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.lightBlue),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30)))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
