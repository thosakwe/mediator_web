import 'dart:io';
import 'package:angel_hot/angel_hot.dart';
import 'package:mediator_server/mediator_server.dart';

main() async {
  HttpServer server;
  InternetAddress host = InternetAddress.LOOPBACK_IP_V4;
  int port = 3000;

  if (Platform.environment['ANGEL_ENV'] == 'production') {
    // In production, we don't want to hot-reload the server.
    // Let's start it like normal here.
    var app = await createServer();
    server = await app.startServer(host, port);
  } else {
    // In development, let's use hot-reloading on our server,
    // so that we don't have to constantly restart it. The HotReloader
    // listens for file changes, and updates our server in-place.
    var hot = new HotReloader(createServer, [
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
