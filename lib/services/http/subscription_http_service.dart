import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:sportmen_in_gym/services/db/sportsman_db_service.dart';

import '../../models/sportsman.dart';
import '../../models/subscription.dart';
import 'http_service.dart';

class SubscriptionHttpService extends HttpService<Subscription>{

  final SportsmanDBService _dbService = SportsmanDBService();

  Future<List<Subscription>> getBySportsman(Sportsman sportsman) async {
    final uri = Uri.http(url, '/subscription/${sportsman.id}');
    try {
      Response res = await get(uri, headers: <String, String>{
        HttpHeaders.authorizationHeader: basicAuth(sportsman.email, sportsman.password)
      });
      print(res.body);
      List<Subscription> subscriptions;
      switch (res.statusCode) {
        case 200:
          subscriptions = (jsonDecode(res.body) as List).map((e) => Subscription.fromJson(e)).toList();
          Sportsman? sportsman = _dbService.getFirst();
          sportsman!.subscriptions = subscriptions;
          _dbService.put(sportsman);
          return subscriptions;
        default:
          throw Exception(res.reasonPhrase);
      }
    } on SocketException catch (_) {
      throw Exception('No connection');
    }
  }
}