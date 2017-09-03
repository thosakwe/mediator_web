import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_validate/server.dart';
import 'package:http/http.dart' as http;
import 'package:pool/pool.dart';
import 'package:pub_mediator/pub_mediator.dart';
import 'package:pubspec/pubspec.dart';

AngelConfigurer configureServer() {
  var validator = new Validator({
    'pubspec*': [
      isNonEmptyString,
      hasLength(greaterThanOrEqualTo(19)),
    ]
  });

  var pool = new Pool(5);
  var client = new http.Client();

  return (Angel app) async {
    // Register an API
    app.chain(validate(validator)).post('/api/diagnose',
        (RequestContext req) async {
      PubSpec ps;

      try {
        ps = new PubSpec.fromYamlString(req.body['pubspec']);
      } catch (_) {
        throw new AngelHttpException.badRequest(message: 'Invalid pubspec.');
      }

      var buf = new StringBuffer();
      var resx = await pool.request();

      var zoneSpec = new ZoneSpecification(
          print: (Zone self, ZoneDelegate parent, Zone zone, msg) {
        var now = new DateTime.now().toUtc().toIso8601String();
        buf.writeln('[$now] $msg');
      });

      try {
        var zone = Zone.current.fork(specification: zoneSpec);
        var diagnosis = await zone.run<DependencyDiagnosis>(
            () => diagnoseConflicts(ps, client, verbose: true));
        var conflicts = diagnosis.conflicts
            .where((c) => c.type != DependencyConflictType.SDK);

        return {
          'log': buf.toString(),
          'conflicts': conflicts.map((conflict) {
            return {
              'name': conflict.packageName,
              'requirements': conflict.requirements.map((dep) {
                return {
                  'name': dep.packageName,
                  'version': dep.dependency.toJson()
                };
              }).toList()
            };
          }).toList()
        };
      } finally {
        resx.release();
      }
    });

    // Destroy pool and client on app shutdown
    app.justBeforeStop.add((_) {
      pool.close();
      client.close();
    });
  };
}
