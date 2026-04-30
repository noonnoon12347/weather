import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = "c507dadaf0cf4ccea19102227262204";

class WeatherApiService {
  final String _baseUrl = "https://api.weatherapi.com/v1";
  Future<Map<String, dynamic>> getHourForecast(String location) async {
    final url = Uri.parse(
      "$_baseUrl/forecast.json?key=$apiKey&q=$location&days=7",
    );

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch data: ${res.body}");
    }
    final data = json.decode(res.body);
    // check error
    if (data.containsKey('error')) {
      throw Exception(data['error']['message'] ?? 'Invalid location');
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getPastSevenDaysWeather(
    String location,
  ) async {
    final List<Map<String, dynamic>> pastPastSevenDaysWeather = [];
    final today = DateTime.now();
    for (int i = 1; i <= 7; i++) {
      final data = today.subtract(Duration(days: i)); //delete days return
      final formattedDate =
          "${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
      final url = Uri.parse(
        "$_baseUrl/history.json?key=$apiKey&q=$location&dt=$formattedDate", // Push history
      );
      final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
    
    // check error
    if (data.containsKey('error')) {
      throw Exception(data['error']['message'] ?? 'Invalid location');
    }// check forecastday
      if(data['forecast']?['forecastday']!=null){
        pastPastSevenDaysWeather.add(data);
      }
    } else{
      debugPrint('Failed to fetch data for $formattedDate: ${res.body}');
    }
    }
    return pastPastSevenDaysWeather;
  }
}
