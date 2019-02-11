import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:segmented_cache/entities/repository_data.dart';

class UserDetailsCacheRepository {
  final String key;

  UserDetailsCacheRepository(this.key);

  Future<RepositoryData> get() async {
    final prefs = await SharedPreferences.getInstance();
    final strRepository = prefs.getString(key);

    if (strRepository != null) {
      return RepositoryData
          .fromJson(jsonDecode(strRepository))
          .copyWith(source: Source.CACHE);
    }

    return RepositoryData(<String, dynamic>{}, source: Source.CACHE);
  }

  Future<bool> save(RepositoryData repository) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonRepository = repository.toJson();
    final strRepository = jsonEncode(jsonRepository);

    return await prefs.setString(key, strRepository);
  }
}