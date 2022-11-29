import 'dart:convert';
import 'package:http/http.dart';
import 'package:sportmen_in_gym/models/sportsman.dart';

import '../../models/visit.dart';
import 'http_service.dart';

class VisitHttpService extends HttpService<Visit>{

  Future<List<Visit>> getBySportsman(Sportsman sportsman) async {
    final uri = Uri.http(url, '/visit/getBySportsman/${sportsman.id}');
    Response res = await get(uri,
        headers: <String, String>{
          'authorization' : basicAuth(sportsman.email, sportsman.password)
        });
    print(res.body);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
      Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }

  Future<List<Visit>> getBySubscription(Sportsman sportsman) async {
    final uri = Uri.http(url, '/visit/getBySubscription/${sportsman.id}');
    Response res = await get(uri,
        headers: <String, String>{
          'authorization' : basicAuth(sportsman.email, sportsman.password)
        });
    print(res.body);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
          Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }
}