// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'client.dart';
import 'document.dart';

class MockJSONAPIClient implements JSONAPIClient {
  var request; // unused

  String _url;
  String get requestUrl => _url;

  String _payload;
  String get requestPayload => _payload;

  List<String> _includeModels;
  List<String> get requestIncludedModels => _includeModels;

  Map _headers;
  Map get requestHeaders => _headers;

  var _desiredOutput;

  setOutput(dynamic output){
    _desiredOutput = output;
  }

  Future<JSONAPIDocument> get(String url,
      {List<String> includeModels: null, Map headers: null}) async {
        _url = url;
        _payload = null;
        _includeModels = includeModels;
        _headers = headers;

        return new Future.value(_desiredOutput);
      }

  Future<JSONAPIDocument> post(String url, String payload,
    {List<String> includeModels, Map headers}) async {
      _url = url;
      _payload = payload;
      _includeModels = includeModels;
      _headers = headers;

      return new Future.value(_desiredOutput);
    }

  Future delete(String url, {Map headers}) async {
    _url = url;
    _payload = null;
    _includeModels = null;
    _headers = headers;

    return new Future.value(_desiredOutput);
  }
}
