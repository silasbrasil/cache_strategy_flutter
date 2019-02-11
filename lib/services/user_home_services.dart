import 'dart:async';

import 'package:segmented_cache/entities/user.dart';
import 'package:segmented_cache/entities/repository_data.dart';
import 'package:segmented_cache/repositories/user_home_api_repository.dart';
import 'package:segmented_cache/repositories/user_home_cache_repository.dart';

class UserHomeServices {
  final UsersHomeApiRepository _usersHomeApi;
  final UsersHomeCacheRepository _usersHomeCache;

  factory UserHomeServices() {
    final url = 'https://jsonplaceholder.typicode.com/users';
    final key = 'users';

    return UserHomeServices._(
      UsersHomeApiRepository(url),
      UsersHomeCacheRepository(key),
    );
  }

  UserHomeServices._(this._usersHomeApi, this._usersHomeCache);

  Future<RepositoryData> list() async {
    final cacheRepository = await _usersHomeCache.get();
    return cacheRepository.isNotEmpty ? cacheRepository : await updateFromApi();
  }

  Future<RepositoryData> updateFromApi() async {
    final apiRepository = await _usersHomeApi.get();

    await _usersHomeCache.save(apiRepository);

    return apiRepository;
  }

  Future<bool> updateWith(List<User> userList) async {
    final cacheRepository = await _usersHomeCache.get();
    final List<dynamic> newList =
        userList.map((user) => user.toJson()).toList();

    final newRepository = cacheRepository.copyWith(data: newList);
    return await _usersHomeCache.save(newRepository);
  }
}
