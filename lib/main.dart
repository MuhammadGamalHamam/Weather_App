import 'dart:io';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/data/repository.dart';
import 'package:weather_app/start_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'current_weather.dart';

void main() {
  initializeDateFormatting('pt_BR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          CurrentWeatherScreen.routeName: (context) => CurrentWeatherScreen(),
        },
        title: 'Current Weather App',
        theme:
            ThemeData(primarySwatch: Colors.blue, highlightColor: Colors.amber),
        home: BlocProvider(
          create: (context) => WeatherBloc(Repository()),
          child: MyHomePage(title: 'Current Weather'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              widget.title,
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                WeatherBloc weatherBloc = BlocProvider.of<WeatherBloc>(context);
                if (weatherBloc.state is WeatherIsNotSearchedState) {
                  weatherBloc.close();
                  exit(0);
                } else {
                  weatherBloc.add(ResetWeatherEvent());
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: MainPage(),
          ),
        ],
      )),
      backgroundColor: Colors.grey[900],
      resizeToAvoidBottomInset: false,
    );
  }
}
