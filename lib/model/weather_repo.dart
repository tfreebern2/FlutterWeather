import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:geolocation/geolocation.dart';

import 'package:weather/json/response.dart';

import 'package:weather/model/model.dart';
import 'package:weather/const.dart';

class WeatherRepo {
  final http.Client client;

  WeatherRepo({this.client});

  Future<List<WeatherModel>> updateWeather(LocationResult result) async {
    String url;
    if (result != null) {
      url = 'http://api.openweathermap.org/data/2.5/find?lat=${result.location.latitude}&lon=${result.location.longitude}&cnt=10&appid=$API_key';
    } else {
      url = 'http://api.openweathermap.org/data/2.5/find?lat=28.75&lon=-81.31&cnt=10&appid=$API_key';
    }
  }
}