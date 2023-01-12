import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../../models/account.dart';
import '../../models/subscription.dart';
import 'http_service.dart';

class SubscriptionHttpService extends HttpService<Subscription> {

  Future<List<Subscription>> getByAccount(Account account) async {
    final uri = Uri.http(url, '/sportsmanDetails/subscriptions/${account.email}');
    try {
      Response res = await get(uri, headers: <String, String>{
        HttpHeaders.authorizationHeader: basicAuth(account.email, account.password)
      });
      List<Subscription> subscriptions;
      switch (res.statusCode) {
        case 200:
          subscriptions = (jsonDecode(res.body) as List).map((e) => Subscription.fromJson(e)).toList();
          return subscriptions;
        default:
          throw Exception(res.reasonPhrase);
      }
    } on SocketException catch (_) {
      throw Exception('No connection');
    }
  }

  Future<bool> addMembership(Account ownAccount, String email,
      String dateOfStart, String dateOfEnd, String numberOfVisits) async {
    final params = {
      "email": email,
      "dateOfStart": dateOfStart,
      "dateOfEnd": dateOfEnd,
      "numberOfVisits": numberOfVisits
    };
    final uri = Uri.http(url, '/manager/addMembership', params);
    try {
      Response res = await post(uri,
          headers: <String, String>{
            HttpHeaders.authorizationHeader:
                basicAuth(ownAccount.email, ownAccount.password),
            HttpHeaders.contentTypeHeader: 'application/json',
          });
      if (res.statusCode == 200) {
        return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }
}