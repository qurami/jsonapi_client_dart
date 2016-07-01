// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'document.dart';

class JSONAPIClient {
  final _JSONAPIDefaultHeaders = new Map<String, String>()
  ..['Accept'] = 'application/vnd.api+json'
  ..['Content-Type'] = 'application/vnd.api+json';

  http.Request request;

  var _http;

  JSONAPIClient({dynamic httpClient: null}) {
    if (httpClient != null) {
      _http = httpClient;
    } else {
      _http = new BrowserClient();
    }
  }

  Future<JSONAPIDocument> get(String url,
      {List<String> includeModels, Map headers}) async {
    return _call('GET', url,
        includeModels: includeModels, additionalHeaders: headers);
  }

  Future<JSONAPIDocument> post(String url, Object document,
      {List<String> includeModels, Map headers}) async {
    return _call('POST', url,
        payload: document,
        includeModels: includeModels,
        additionalHeaders: headers);
  }

  Future<JSONAPIDocument> delete(String url, {Map headers}) async {
    return _call('DELETE', url, additionalHeaders: headers);
  }

  Uri _composeUri(String url, List<String> includeModels) {
    String queryOperator = '?';
    if (url.contains(queryOperator)){
      queryOperator = '&';
    }

    if (includeModels != null) {
      url += queryOperator + "include=" + includeModels.join(",");
    }

    return path.toUri(url);
  }

  _call(String method, String url,
      {dynamic payload: null,
      List<String> includeModels: null,
      Map additionalHeaders: null}) async {

    request = new http.Request(method, _composeUri(url, includeModels));

    if (payload != null)
      request.body = payload;

    request.headers.addAll(_JSONAPIDefaultHeaders);
    if (additionalHeaders != null) {
      request.headers.addAll(additionalHeaders);
    }

    http.StreamedResponse response = await _http.send(request);

    switch (method){
      case 'POST':
        switch (response.statusCode){
          case 202: // Accepted
          case 204: // No content
            return null;
        }
        continue defaultCase;

      case 'DELETE':
        switch (response.statusCode){
          case 204: // No content
            return null;
        }
        continue defaultCase;

    defaultCase:
      case 'GET':
      default:
        return new JSONAPIDocument(JSON.decode(await response.stream.bytesToString()));
    }
  }
}
