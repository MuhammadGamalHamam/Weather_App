import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/weather_bloc.dart';

class SearchComponent extends StatelessWidget {
  static TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32, top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: FlareActor(
              "assets/WorldSpin.flr",
              fit: BoxFit.contain,
              animation: "roll",
            ),
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) {
              _onWeatherSearch(context, _textController.text);
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
            ],
            controller: _textController,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        color: Colors.white, style: BorderStyle.solid)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                        color: Colors.white, style: BorderStyle.solid)),
                hintText: "City",
                hintStyle: TextStyle(color: Colors.white)),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () {
                _onWeatherSearch(context, _textController.text);
              },
              child: Text("Search",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.green),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30)))),
            ),
          ),
        ],
      ),
    );
  }

  _onWeatherSearch(BuildContext context, text) {
    FocusScope.of(context).unfocus();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "Enter the Name of the City",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ));
      return;
    }
    BlocProvider.of<WeatherBloc>(context).add(FetchWeatherEvent(text));
  }
}
