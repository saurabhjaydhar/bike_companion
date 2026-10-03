import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/rc_details.dart';

enum RcLookupStatus { success, notFound, apiLimitExceeded, networkError, unknown }

class RcLookupResult {
  final RcLookupStatus status;
  final RcDetails? details;

  const RcLookupResult({required this.status, this.details});
}

/// Looks up RC details by registration number through a VAHAN-connected
/// data provider. Configure at build time:
///   `--dart-define=RC_LOOKUP_URL=https://your-proxy.example/rc/lookup`
///   `--dart-define=RC_LOOKUP_KEY=...` (optional)
/// Point the URL at your own backend (e.g. a Cloud Function) that holds the
/// provider's credentials — a key compiled into the app can be extracted.
/// The lookup option is hidden in the app until a URL is set.
class RcLookupService {
  static const _url = String.fromEnvironment('RC_LOOKUP_URL');
  static const _apiKey = String.fromEnvironment('RC_LOOKUP_KEY');
  static const _timeout = Duration(seconds: 15);

  static bool get isConfigured => _url.isNotEmpty;

  Future<RcLookupResult> lookup(String rcNumber) async {
    try {
      final client = HttpClient()..connectionTimeout = _timeout;

      final request =
          await client.postUrl(Uri.parse(_url)).timeout(_timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      if (_apiKey.isNotEmpty) request.headers.set('x-api-key', _apiKey);
      request.write(jsonEncode({'reg_no': rcNumber}));

      final response = await request.close().timeout(_timeout);
      final body = await response.transform(utf8.decoder).join();
      client.close();

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(body) as Map<String, dynamic>;
          return RcLookupResult(
            status: RcLookupStatus.success,
            details: RcDetails.fromApiResponse(json, rcNumber),
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
