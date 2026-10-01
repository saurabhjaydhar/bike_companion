import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/vehicle.dart';

enum RcLookupStatus { success, notFound, apiLimitExceeded, networkError, unknown }

class RcLookupResult {
  final RcLookupStatus status;
  final Vehicle? vehicle;

  const RcLookupResult({required this.status, this.vehicle});
}

class RcLookupService {
  static const _url = 'https://your-rc-api.example.com/v1/rc/lookup';
  static const _apiKey = 'YOUR_KEY';
  static const _timeout = Duration(seconds: 15);

  Future<RcLookupResult> lookup(String rcNumber) async {
    try {
      final client = HttpClient()..connectionTimeout = _timeout;

      final request =
          await client.postUrl(Uri.parse(_url)).timeout(_timeout);
      request.headers
        ..set(HttpHeaders.contentTypeHeader, 'application/json')
        ..set('x-api-key', _apiKey);
      request.write(jsonEncode({'reg_no': rcNumber}));

      final response = await request.close().timeout(_timeout);
      final body = await response.transform(utf8.decoder).join();
      client.close();

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(body) as Map<String, dynamic>;
          return RcLookupResult(
            status: RcLookupStatus.success,
            vehicle: Vehicle.fromApiResponse(json, rcNumber),
          );
        case 404:
          return const RcLookupResult(status: RcLookupStatus.notFound);
        case 429:
          return const RcLookupResult(status: RcLookupStatus.apiLimitExceeded);
        default:
          return const RcLookupResult(status: RcLookupStatus.unknown);
      }
    } on SocketException {
      return const RcLookupResult(status: RcLookupStatus.networkError);
    } catch (_) {
      return const RcLookupResult(status: RcLookupStatus.unknown);
    }
  }
}

final rcLookupServiceProvider = Provider<RcLookupService>((ref) {
  return RcLookupService();
});
