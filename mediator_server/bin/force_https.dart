import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'package:angel_multiserver/angel_multiserver.dart';

main() async {
// Mount a server on port 80 to force HTTPS redirects
  var stub = new Angel()..before.add(forceHttps());
  var stubServer = await stub.startServer(InternetAddress.ANY_IP_V4, 80);
  print(
      'Forcing HTTPS redirects from http://${stubServer.address.address}:${stubServer.port}');
}
