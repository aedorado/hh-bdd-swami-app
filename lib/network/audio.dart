import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hh_bbds_app/models/podo/audio.dart';
import 'package:hh_bbds_app/models/response_model/audio_response.dart';
import 'package:http/http.dart' as http;

Future<List<Audio>> fetchAudios() async {
  final response =
  await http.get(Uri.parse('https://mocki.io/v1/6817415e-fc15-4ed5-b6a2-e811e45802f5'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    AudioResponse ar = AudioResponse.fromJson(jsonDecode(response.body));
    return ar.audios;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load audios');
  }
}