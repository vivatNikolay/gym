import 'dart:convert';
import 'package:http/http.dart';

import '../../models/sportsman.dart';
import 'http_service.dart';

class SportsmanHttpService extends HttpService<Sportsman>{

  Future<Sportsman> getByEmail(String email) async {
    Response res = await get(Uri.parse(url+"/sportsman/$email"));
    print(res.body);
    if (res.statusCode == 200) {
      Sportsman sportsman = Sportsman.fromJson(jsonDecode(res.body));
      return sportsman;
    } else {
      throw "Unable to retrieve sportsman.";
    }
  }
}