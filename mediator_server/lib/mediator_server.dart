library mediator_server;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:angel_common/angel_common.dart';
import 'src/api.dart' as api;

/// Generates and configures an Angel server.
Future configureServer(Angel app) async {
  app..lazyParseBodies = true;

  // Loads app configuration from 'config/'.
  // It supports loading from YAML files, and also supports loading a `.env` file.
  //
  // https://github.com/angel-dart/configuration
  await app.configure(loadConfigurationFile());

  // Attach API routes...
  await app.configure(api.configureServer());

  // Proxy over `pub serve` in development
  await app.configure(new PubServeLayer());

  // Sets up a static server (with caching support).
  // Defaults to serving out of 'web/'.
  // In production mode, it'll try to serve out of `build/web/`.
  //
  // https://github.com/angel-dart/static
  await app.configure(new CachingVirtualDirectory(
      source: new Directory(app.isProduction
          ? '../mediator_web/build/web'
          : '../mediator_web/web')));

  // Routes in `app.after` will only run if the request was not terminated by a prior handler.
  // Usually, this is a situation in which you'll want to throw a 404 error.
  // On 404's, let's redirect the user to a pretty error page.
  app.after.add((ResponseContext res) => res.redirect('/not-found.html'));

  // Faster JSON encoding
  app.injectSerializer(JSON.encode);

  // Enable GZIP and DEFLATE compression (conserves bandwidth)
  // https://github.com/angel-dart/compress
  app.injectEncoders({
    'gzip': GZIP.encoder,
    'deflate': ZLIB.encoder,
  });

  // Logs requests and errors to both console, and a file named `log.txt`.
  // https://github.com/angel-dart/diagnostics
  await app.configure(logRequests(new File('log.txt')));
}
