/*
import 'dart:async';
import "dart:convert";

//import 'package:qurami_com/services/qurami_bdm/qurami_http_client.dart';

class JSONAPIClient {
  String lastRequestURL;
  Map lastRequestHeaders;

  final QuramiHTTPClient _http;

  JSONAPIClient(this._http);

  String _composeUrl(String url, String objectId, List<String> includeModels) {
    if (objectId != null) {
      url += "/" + objectId;
    }

    if (includeModels != null) {
      url += "?include=" + includeModels.join(",");
    }

    return url;
  }

  _call(String method, String url,
      {String objectId: null,
      String payload: null,
      List<String> includeModels: null,
      Map additionalHeaders: null}) async {
    String dataUrl = _composeUrl(url, objectId, includeModels);

    var parameters;
    if (payload != null) parameters = payload;

    Map<String, String> requestHeaders = new Map<String, String>();
    requestHeaders['Accept'] = 'application/vnd.api+json';
    requestHeaders['Content-Type'] = 'application/vnd.api+json';
    requestHeaders['X-Nova-Version'] = '2';

    if (additionalHeaders != null) {
      requestHeaders.addAll(additionalHeaders);
    }

    lastRequestURL = dataUrl;
    lastRequestHeaders = requestHeaders;

    String response =
        await _http.execute(method, dataUrl, requestHeaders, parameters);

    print("Calling URL: " + dataUrl);

    JSONAPIDocument document = new JSONAPIDocument();

    // ticket delete return empty
    if (response.isNotEmpty) {
      Map outputMap = JSON.decode(response);

      if (outputMap.containsKey('errors')) {
        document.errors = outputMap['errors'];
      }

      if (outputMap.containsKey('data')) {
        document.data = outputMap['data'];
      }

      if (outputMap.containsKey('included')) {
        document.included = outputMap['included'];
      }

      if (outputMap.containsKey('meta')) {
        document.meta = outputMap['meta'];
      }
    }
    return document;
  }

  Future<JSONAPIDocument> get(String url,
      {String objectId, List<String> includeModels, Map headers}) async {
    return _call('GET', url,
        objectId: objectId,
        includeModels: includeModels,
        additionalHeaders: headers);
  }

  Future<JSONAPIDocument> post(String url, Object document,
      {List<String> includeModels, Map headers}) async {
    return _call('POST', url,
        payload: document,
        includeModels: includeModels,
        additionalHeaders: headers);
  }

  Future<JSONAPIDocument> delete(String url,
      {String objectId, Map headers}) async {
    return _call('DELETE', url, objectId: objectId, additionalHeaders: headers);
  }
}

*/
