// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'client.dart';
import 'document.dart';

class MockJSONAPIClient implements JSONAPIClient {
  var request; // unused

  var _desiredOutput;

  setOutput(dynamic output){
    _desiredOutput = output;
  }

  Future<JSONAPIDocument> get(String url,
      {List<String> includeModels, Map headers}) async {
        return new Future.value(_desiredOutput);
      }

  Future<JSONAPIDocument> post(String url, String document,
    {List<String> includeModels, Map headers}) async {
      return new Future.value(_desiredOutput);
    }

  Future delete(String url, {Map headers}) async {
    return new Future.value(_desiredOutput);
  }
}
