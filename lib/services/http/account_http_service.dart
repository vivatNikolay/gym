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
    print(res.body);
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
}