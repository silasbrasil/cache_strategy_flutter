import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:segmented_cache/entities/repository_data.dart';

class UserDetailsApiRepository {
  final String url;

  UserDetailsApiRepository(this.url);

  Future<RepositoryData> get() async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return RepositoryData(jsonDecode(response.body), source: Source.API);
    }

    throw Exception('Deu merda...');
  }
}