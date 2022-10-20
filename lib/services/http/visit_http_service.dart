import 'dart:convert';
import 'package:http/http.dart';

import '../../models/visit.dart';
import 'http_service.dart';

class VisitHttpService extends HttpService<Visit>{

  Future<List<Visit>> getBySportsman(int id, DateTime start, DateTime end) async {
    final queryParameters = {
      'dateStart': start.toString(),
      'dateEnd': end.toString(),
    };
    final uri = Uri.http(url, '/visit/$id', queryParameters);

    Response res = await get(uri);
    print(res.body);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
      Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }
}