import 'dart:convert';
import 'package:http/http.dart';

import '../../models/visit.dart';
import 'http_service.dart';

class VisitHttpService extends HttpService<Visit>{

  Future<List<Visit>> getBySportsman(int id) async {
    Response res = await get(Uri.parse(url+"/visit/$id"));
    print(res.body);
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((i) =>
      Visit.fromJson(i)).toList();
    } else {
      throw "Unable to retrieve visits.";
    }
  }
}