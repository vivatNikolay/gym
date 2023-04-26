import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../../models/account.dart';
import 'http_service.dart';

class AccountHttpService extends HttpService<Account>{
  Future<Account> login(String email, String pass) async {
    final uri = Uri.http(url, '/account/login');
    try {
      Response res = await get(uri, headers: <String, String>{
        HttpHeaders.authorizationHeader: basicAuth(email, pass)
      });
      if (res.statusCode == 200) {
        Account account = Account.fromJson(jsonDecode(res.body));
        return account;
      } else {
        throw 'Неверный логин или пароль';
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }

  Future<void> update(Account ownAccount, Account newAccount) async {
    final uri = Uri.http(url, '/account/update');
    try {
      await put(uri,
          headers: <String, String>{
            HttpHeaders.authorizationHeader:
                basicAuth(ownAccount.email, ownAccount.password),
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(newAccount.toJson()));
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }

  Future<void> edit(Account ownAccount, Account newAccount) async {
    final uri = Uri.http(url, '/manager/edit');
    try {
      await put(uri,
          headers: <String, String>{
            HttpHeaders.authorizationHeader:
                basicAuth(ownAccount.email, ownAccount.password),
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(newAccount.toJson()));
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }

  Future<void> create(Account ownAccount, Account newAccount) async {
    final uri = Uri.http(url, '/manager/create');
    try {
      Response res = await post(uri,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: basicAuth(ownAccount.email, ownAccount.password),
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(newAccount.toJson()));
      if (res.statusCode != 200) {
        throw 'Аккаунт с такой почтой уже есть';
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }

  Future<List<Account>> getSportsmenByQuery(Account account, String query) async {
    final queryParameters = {
      'query': query,
    };
    final uri = Uri.http(url, '/manager/sportsmen', queryParameters);
    List<Account> accounts = List.empty();
    try {
      Response res = await get(uri, headers: <String, String>{
        HttpHeaders.authorizationHeader: basicAuth(account.email, account.password),
      });
      if (res.statusCode == 200) {
        accounts = (jsonDecode(res.body) as List)
            .map((e) => Account.fromJson(e))
            .toList();
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
    return accounts;
  }

  Future<Account> getSportsman(Account account, String id) async {
    final queryParameters = {
      'id': id,
    };
    final uri = Uri.http(url, '/manager/sportsman', queryParameters);
    try {
      Response res = await get(uri, headers: <String, String>{
        HttpHeaders.authorizationHeader: basicAuth(account.email, account.password),
      });
      if (res.statusCode == 200) {
        Account account = Account.fromJson(jsonDecode(res.body));
        return account;
      } else {
        throw "Аккаунт не найден";
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }
}
