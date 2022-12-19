import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../../models/account.dart';
import 'http_service.dart';

class AccountHttpService extends HttpService<Account>{

  Future<Account> login(String email, String pass) async {
    final uri = Uri.http(url, '/account/login');
    Response res = await get(uri, headers: <String, String>{
      HttpHeaders.authorizationHeader: basicAuth(email, pass)
    });
    if (res.statusCode == 200) {
      Account account = Account.fromJson(jsonDecode(res.body));
      return account;
    } else {
      throw "Unable to retrieve account.";
    }
  }

  Future<bool> update(Account account) async {
    final uri = Uri.http(url, '/account/update');
    try {
      Response res = await put(uri,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: basicAuth(account.email, account.password),
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(account.toJson()));
      if (res.statusCode == 200) {
        return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }

  Future<List<Account>> getSportsmen(Account account, String? query) async {
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
    } on Exception {
      return List.empty();
    }
    return accounts;
  }
}
