import 'dart:convert';

abstract class HttpService<T> {
  final String url = "192.168.100.6:8080";

  String basicAuth(String user, String pass) {
    return 'Basic ' + base64Encode(utf8.encode('$user:$pass'));
  }
}