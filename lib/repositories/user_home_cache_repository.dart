import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:segmented_cache/entities/repository_data.dart';

class UsersHomeCacheRepository {
  final String key;

  UsersHomeCacheRepository(this.key);

  Future<RepositoryData> get() async {
    final prefs = await SharedPreferences.getInstance();
    final strRepository = prefs.getString(key);

    if (strRepository != null) {
      final repoData = RepositoryData.fromJson(jsonDecode(strRepository));
      return repoData.copyWith(source: Source.CACHE);
    }

    return RepositoryData(<dynamic>[], source: Source.CACHE);
  }

  Future<bool> save(RepositoryData repository) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonRepository = repository.toJson();
    final strRepository = jsonEncode(jsonRepository);

    return await prefs.setString(key, strRepository);
  }
}
