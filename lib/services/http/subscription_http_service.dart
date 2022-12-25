import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../../models/account.dart';
import '../../models/subscription.dart';
import 'http_service.dart';

class SubscriptionHttpService extends HttpService<Subscription>{

  Future<List<Subscription>> getByAccount(Account account) async {
    final uri = Uri.http(url, '/sportsmanDetails/subscriptions/${account.id}');
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
}