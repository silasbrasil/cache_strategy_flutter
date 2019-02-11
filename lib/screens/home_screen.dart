import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:segmented_cache/services/user_home_services.dart';
import 'package:segmented_cache/services/user_details_services.dart';

import 'package:segmented_cache/entities/user.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeServices = UserHomeServices();
  final detailsServices = UserDetailsService(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cache'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('List Users'),
              onPressed: () {
                list();
              },
            ),
            RaisedButton(
              child: Text('Update Users'),
              onPressed: () {
                update();
              },
            ),
            RaisedButton(
              child: Text('Get User'),
              onPressed: () {
                print('User:');
                getUser();
              },
            ),
            RaisedButton(
              child: Text('Update User'),
              onPressed: () {
                updateUser();
              },
            ),
            RaisedButton(
              child: Text('Update List of User'),
              onPressed: () {
                updateUserOfList();
              },
            ),
            RaisedButton(
              child: Text('List Keys'),
              onPressed: () {
                listKeys();
              },
            ),
            RaisedButton(
              child: Text('Clear cache'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                print('Clean');
              },
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void list() async {
    final repository = await homeServices.list();
    final list = repository.data;

    print('---------------------------');
    print('FONTE: ${repository.source}');
    print('---------------------------');

    final userList = list
        .map((it) => User.fromJson(it))
        .toList();

    userList.forEach((user) {
      print(user.id);
      print(user.name);
      print(user.email);
      print('----------');
    });
  }

  void update() async {
    final repository = await homeServices.updateFromApi();
    final List<dynamic> list = repository.data;

    final userList = list
        .map((it) => User.fromJson(it))
        .toList();

    print('---------------------------');
    print('FONTE: ${repository.source}');
    print('---------------------------');

    userList.forEach((user) {
      print(user.id);
      print(user.name);
      print(user.email);
    });
  }

  void getUser() async {
    final repository = await detailsServices.list();
    final jsonUser = repository.data;

    print('---------------------------');
    print('FONTE: ${repository.source}');
    print('---------------------------');

    final user = User.fromJson(jsonUser);
    print('------');
    print(user.id);
    print(user.name);
    print(user.email);
    print('------');
  }

  void updateUser() async {
    final user = User(45, 'Jhonatan', 'jhonatan@gmail.com');

    final oldRepository = await detailsServices.list(); // apenas um usuário
    final newRepository = oldRepository.copyWith(data: user.toJson());

    print('---------------------------');
    print('FONTE: ${newRepository.source}');
    print('---------------------------');

    await detailsServices.save(newRepository);

    print('Salvo com sucesso!');
  }

  void updateUserOfList() async {
    /// Pega a lista no cache
    final repository = await homeServices.list();
    final List<dynamic> list = repository.data;
    final userList = list
        .map((it) => User.fromJson(it))
        .toList();

    /// Atualiza a lista
    final user = User(32, 'Silas Brasil', 'silas@gmail.com');
    userList.add(user);

    print('---------------------------');
    print('FONTE: ${repository.source}');
    print('---------------------------');

    /// Salva a lista no cache
    await homeServices.updateWith(userList);

    print('Cache atualizada com sucesso!');
  }

  void listKeys() async {
    final prefs = await SharedPreferences.getInstance();

    print('Keys: ');
    prefs.getKeys().forEach((key) {
      if (key.startsWith('users')) {
        print('Essa chave começa com users: $key');
      }
    });
  }
}