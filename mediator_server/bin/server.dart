import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:angel_multiserver/angel_multiserver.dart';
import 'package:mediator_server/mediator_server.dart';

main() async {
  HttpServer server;
  InternetAddress host = InternetAddress.LOOPBACK_IP_V4;
  int port = 3000;

  if (Platform.environment['ANGEL_ENV'] == 'production') {
    // Mount a server on port 80 to force HTTPS redirects
    var stub = new Angel()..before.add(forceHttps());
    var stubServer = await stub.startServer(InternetAddress.ANY_IP_V4, 80);
    print('Forcing HTTPS redirects from http://${stubServer.address}:${stubServer.port}');

    // In production, we don't want to hot-reload the server.
    // Let's start it like normal here.
    var app = new Angel.secure('/etc/ssl/certs/nginx-selfsigned.crt',
        '/etc/ssl/private/nginx-selfsigned.key');
    server = await app.startServer(host, port = 443);
  } else {
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
  }

  print('Listening at http://${server.address.address}:${server.port}');
}
