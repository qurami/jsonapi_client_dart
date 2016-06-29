// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import "package:jsonapi_client/jsonapi_client.dart";
import "package:test/test.dart";

void main() {
  group("test Error creation", () {
    test("create a JSONAPIError from a correct Map", () {
      Map errorMap = new Map();
      errorMap['status'] = '500';
      errorMap['detail'] = 'Internal server error';

      JSONAPIError expectedError = new JSONAPIError(errorMap);

      expect(expectedError.status, equals('500'));
      expect(expectedError.detail, equals('Internal server error'));
    });
  });

  group("test Error conversion", () {
    test("encode JSONAPIError into a Map", () {
      String inputJson = '{"status":"500","detail":"Internal server error"}';

      Map aMap = JSON.decode(inputJson);
      JSONAPIError error = new JSONAPIError(aMap);
      String outputJson = JSON.encode(error);

      expect(outputJson, equals(inputJson));
    });
  });
}
