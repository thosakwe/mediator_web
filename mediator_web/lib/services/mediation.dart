import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:angel_client/browser.dart';
import 'package:angular/angular.dart';

@Injectable()
class MediationService {
  final Angel _app = new Rest(window.location.origin);

  Future<Map<String, dynamic>> mediate(String pubspec) {
    return _app
        .post('/api/diagnose',
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json'
            },
            body: JSON.encode({'pubspec': pubspec}))
        .then((res) {
      var body = JSON.decode(res.body);

      if (res.statusCode < 200 || res.statusCode >= 400) {
        throw new Exception(body['message'] ?? res.body);
      }

      return body;
    });
  }
}
