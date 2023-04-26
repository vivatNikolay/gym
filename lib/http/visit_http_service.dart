import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../../models/account.dart';
import '../../models/visit.dart';
import 'http_service.dart';

class VisitHttpService extends HttpService<Visit>{

  Future<List<Visit>> getByAccount(Account account) async {
    final uri = Uri.http(url, '/sportsmanDetails/visits/${account.id}');
    try {
      Response res = await get(uri,
          headers: <String, String>{
            'authorization': basicAuth(account.email, account.password)
          });
      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as List).map((i) =>
            Visit.fromJson(i)).toList();
      } else {
        throw 'Посещения не найдены';
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }

  Future<void> addSingleVisit(Account account, ownAccount) async {
    final params = {"id": account.id};
    final uri = Uri.http(url, '/manager/addSingleVisit', params);
    try {
      Response res = await post(uri,
          headers: <String, String>{
            'authorization': basicAuth(ownAccount.email, ownAccount.password)
          });
      if (res.statusCode != 200) {
        throw 'Ошибка при добавлении';
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }

  Future<void> addVisitToMembership(Account account, ownAccount) async {
    final params = {"id": account.id};
    final uri = Uri.http(url, '/manager/addVisitToMembership', params);
    try {
      Response res = await post(uri,
          headers: <String, String>{
            'authorization': basicAuth(ownAccount.email, ownAccount.password)
          });
      if (res.statusCode != 200) {
        throw 'Ошибка при добавлении';
      }
    } on SocketException {
      throw 'Нет интернет соединения';
    } on Exception {
      throw 'Ошибка';
    }
  }
}