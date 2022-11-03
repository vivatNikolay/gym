import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../../models/subscription.dart';
import 'http_service.dart';

class SubscriptionHttpService extends HttpService<Subscription>{

  Future<Subscription?> getBySportsman(int id) async {
    final uri = Uri.http(url, '/subscription/$id');
    try {
      Response res = await get(uri);
      print(res.body);
      switch (res.statusCode) {
        case 200:
          if (res.body.isEmpty) {
            return null;
          }
          return Subscription.fromJson(jsonDecode(res.body));
        default:
          throw Exception(res.reasonPhrase);
      }
    } on SocketException catch (_) {
      throw Exception('No connection');
    }
  }
}