import 'dart:convert';
import 'package:http/http.dart';

import '../../models/sportsman.dart';
import 'http_service.dart';

class SportsmanHttpService extends HttpService<Sportsman>{

  Future<Sportsman> getByEmail(String email) async {
    final uri = Uri.http(url, '/sportsman/$email');
    Response res = await get(uri);
    if (res.statusCode == 200) {
      Sportsman sportsman = Sportsman.fromJson(jsonDecode(res.body));
      return sportsman;
    } else {
      throw "Unable to retrieve sportsman.";
    }
  }

  Future<bool> putByEmail(String email, Sportsman sportsman) async {
    final uri = Uri.http(url, '/sportsman/$email');
    Response res = await put(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(sportsman.toJson()));
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }
}