import 'dart:convert';

import 'package:http/http.dart' as http;

String baseUrl = 'http://bookario.com/apis/';
String imageBaseUrl = 'http://bookario.com/';

Map<String, String> allHeaders = {
  "Content-Type": "application/json",
  "Accept": "application/json",
};

class Networking {
  dynamic post(String route, Map<dynamic, dynamic> parameters) async {
    print('POST: Sending Post Request');

    final response = await http.post(
      Uri(path: baseUrl + route),
      body: json.encode(parameters),
      headers: allHeaders,
    );

    if (response.statusCode == 200) {
      var body;
      try {
        body = jsonDecode(response.body);
      } catch (e) {
        print(e.toString());
        return null;
      }
      return body;
    } else {
      print('Error: ' + response.body);
      return null;
    }
  }

  static dynamic getData(String route, Map<String, dynamic> parameters) async {
    print('Sending Get request...');
    final String queryString = Uri(queryParameters: parameters).query;
    final requestUrl = baseUrl + route + '?' + queryString;
    final response = await http.get(Uri(path: requestUrl));

    if (response.statusCode == 200) {
      var body;
      try {
        body = jsonDecode(response.body);
      } catch (e) {
        print(e.toString());
        return null;
      }
      return body;
    } else {
      print('Error: ' + response.body);
      return null;
    }
  }
}
