import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/weather_bloc.dart';
import 'models/weather_model.dart';

class CityListWidgetState extends State<CityListWidget> {
  List<WeatherModel> _weatherList = List.empty();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      _weatherList =
          BlocProvider.of<WeatherBloc>(context).getWeatherList.toList();

      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Container(
                child: Scrollbar(
                  thickness: 3,
                  radius: Radius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () async => {
                        BlocProvider.of<WeatherBloc>(context)
                            .add(RefreshCityListEvent())
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount:
                            _weatherList == null ? 0 : _weatherList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[800],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  splashColor: Colors.amber,
                                  onTap: () {
                                    BlocProvider.of<WeatherBloc>(context).add(
                                        OpenSelectedWeatherScreenEvent(
                                            _weatherList[index]));
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 16, left: 16, right: 16),
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.orange[900],
                                                  size: 35,
                                                ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                    _weatherList[index]
                                                        .cityName,
                                                    style: TextStyle(
                                                        fontSize: 26,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                            Center(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 16),
                                                child: FlareActor(
                                                  "assets/weather_${_weatherList[index].icon}.flr",
                                                  fit: BoxFit.contain,
                                                  animation:
                                                      "${_weatherList[index].icon}",
                                                ),
                                                height: 85,
                                                width: 85,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Temperature: ${_weatherList[index].temp} C",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                        "Description: ${_weatherList[index].description[0].toUpperCase() + _weatherList[index].description.substring(1)}",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                        "Atualizado em: ${_weatherList[index].getLastUpdate}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      );
    });
  }
}

class CityListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CityListWidgetState();
  }
}
