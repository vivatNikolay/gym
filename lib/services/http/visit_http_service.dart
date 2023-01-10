import 'dart:convert';
import 'package:http/http.dart';

import '../../models/account.dart';
import '../../models/visit.dart';
import 'http_service.dart';

class VisitHttpService extends HttpService<Visit>{

  Future<List<Visit>> getByAccount(Account account) async {
    final uri = Uri.http(url, '/sportsmanDetails/visits/${account.email}');
    Response res = await get(uri,
        headers: <String, String>{
          'authorization' : basicAuth(account.email, account.password)
        });
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
      Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }

  Future<List<Visit>> getBySubscription(Account account) async {
    final uri = Uri.http(url, '/sportsmanDetails/visitsBySubscription/${account.email}');
    Response res = await get(uri,
        headers: <String, String>{
          'authorization' : basicAuth(account.email, account.password)
        });
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
          Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }

  Future<bool> addVisitToSportsman(Account account, ownAccount) async {
    final params = {"email": account.email};
    final uri = Uri.http(url, '/manager/addVisit', params);
    Response res = await post(uri,
        headers: <String, String>{
          'authorization' : basicAuth(ownAccount.email, ownAccount.password)
        });
    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}