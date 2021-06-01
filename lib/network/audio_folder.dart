import 'dart:convert';
import 'package:hh_bbds_app/models/podo/audio_folder.dart';
import 'package:hh_bbds_app/models/response_model/audio_folder_response.dart';
import 'package:http/http.dart' as http;

Future<List<AudioFolder>> fetchAudioFolders(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.    
    AudioFolderResponse ar = AudioFolderResponse.fromJson(jsonDecode(response.body));
    // debugPrint('${ar.audioFolders.length}');
    return ar.audioFolders;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load audios');
  }
}