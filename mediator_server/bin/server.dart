import 'dart:async';
import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:mediator_server/mediator_server.dart';

main() {
  if (Platform.environment['ANGEL_ENV'] == 'production') {
    return runZoned(productionMain, onError: (e, st) {
      stderr..writeln('TOP-LEVEL ERROR: $e')..writeln(st);
    });
  } else {
    return devMain();
  }
}

productionMain() async {
  HttpServer server;
  InternetAddress host = InternetAddress.ANY_IP_V4;
  int port = 80; //443;

  // Listening on port 80 instead of 443, leverage Cloudflare's HTTPS
  //var app = new Angel.secure('cert.pem', 'key.pem');
  var app = new Angel();
  await app.configure(configureServer);
  server = await app.startServer(host, port);

  print('Listening at http://${server.address.address}:${server.port}');
}

devMain() async {
  HttpServer server;
  InternetAddress host = InternetAddress.ANY_IP_V4;
  int port = 3000;

  // In development, let's use hot-reloading on our server,
  // so that we don't have to constantly restart it. The HotReloader
  // listens for file changes, and updates our server in-place.
  var hot = new HotReloader(() async {
    var app = new Angel();
    await app.configure(configureServer);
    return app;
  }, [
    // We can listen for changes at a multitude of paths.
    new Directory('bin'),
    new Directory('config'),
    new Directory('lib'),
    new File('pubspec.lock')
  ]);
  server = await hot.startServer(host, port);

  print('Listening at http://${server.address.address}:${server.port}');
}
