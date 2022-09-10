import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static Future<IOClient> get _instance async =>
      _clientInstance ??= await getClient;
  static IOClient? _clientInstance;
  static IOClient get client => _clientInstance ?? IOClient();
  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}

Future<IOClient> get getClient async {
  final sslCert = await rootBundle.load('assets/themoviedb.org.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  HttpClient client = HttpClient(context: securityContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;

  return IOClient(client);
}
