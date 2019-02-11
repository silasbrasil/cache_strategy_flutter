import 'dart:async';

import 'package:segmented_cache/entities/repository_data.dart';
import 'package:segmented_cache/repositories/user_details_api_repository.dart';
import 'package:segmented_cache/repositories/user_details_cache_repository.dart';

class UserDetailsService {
  final UserDetailsApiRepository _userDetailsApi;
  final UserDetailsCacheRepository _userDetailsCache;

  factory UserDetailsService(int id) {
    final url = 'https://jsonplaceholder.typicode.com/users/$id';
    final key = 'users/$id';

    return UserDetailsService._(
      UserDetailsApiRepository(url),
      UserDetailsCacheRepository(key),
    );
  }

  UserDetailsService._(this._userDetailsApi, this._userDetailsCache);

  Future<RepositoryData> list() async {
    final cacheRepository = await _userDetailsCache.get();
    return cacheRepository.isNotEmpty ? cacheRepository : await update();
  }

  Future<RepositoryData> update() async {
    final apiRepository = await _userDetailsApi.get();

    await _userDetailsCache.save(apiRepository);

    return apiRepository;
  }

  Future<bool> save(RepositoryData repository) async {
    final result = await _userDetailsCache.save(repository);

    return result;
  }
}
