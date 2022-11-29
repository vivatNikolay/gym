import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import '../../models/sportsman.dart';
import 'http_service.dart';

class SportsmanHttpService extends HttpService<Sportsman>{

  Future<Sportsman> getByEmail(String email, String pass) async {
    final uri = Uri.http(url, '/sportsman/$email');
    Response res = await get(uri, headers: <String, String>{
      HttpHeaders.authorizationHeader: basicAuth(email, pass)
    });
    print(res.body);
    if (res.statusCode == 200) {
      Sportsman sportsman = Sportsman.fromJson(jsonDecode(res.body));
      return sportsman;
    } else {
      throw "Unable to retrieve sportsman.";
    }
  }

  Future<bool> putByEmail(Sportsman sportsman) async {
    final uri = Uri.http(url, '/sportsman/${sportsman.email}');
    try {
      Response res = await put(uri,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: basicAuth(sportsman.email, sportsman.password),
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode(sportsman.toJson()));
      if (res.statusCode == 200) {
        return true;
      }
    } on Exception {
      return false;
    }
    return false;
  }
}