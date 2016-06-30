// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import "package:jsonapi_client/jsonapi_client.dart";
import "package:test/test.dart";

void main() {
  group("test Resource creation", () {
    test("create a JSONAPIResource from a Map", () {
      Map dataMap = new Map();
      dataMap['type'] = 'person';
      dataMap['attributes'] = new Map();
      dataMap['attributes']['name'] = 'Pasquale';

      JSONAPIResource expectedResource = new JSONAPIResource(dataMap);

      expect(expectedResource.type, equals('person'));
    });

    test("create a JSONAPIResource with no type", () {
      Map dataMap = new Map();
      dataMap['attributes'] = new Map();
      dataMap['attributes']['name'] = 'Pasquale';

      expect(() {
        new JSONAPIResource(dataMap);
      }, throwsFormatException);
    });
  });

  group("test Resource conversion", () {
    test("encode JSONAPIResource into a Map", () {
      String inputJson = '{"type":"person","attributes":{"name":"Pasquale"}}';

      Map inputMap = JSON.decode(inputJson);
      JSONAPIResource resource = new JSONAPIResource(inputMap);
      String outputJson = JSON.encode(resource);

      expect(outputJson, equals(inputJson));
    });

    test("encode JSONAPIResourceList into a Map", () {
      String inputJson =
          '[{"type":"person","attributes":{"name":"Pasquale"}},{"type":"person","attributes":{"name":"Federico"}}]';

      List<Map> inputMap = JSON.decode(inputJson);
      JSONAPIResourceList resourceList = new JSONAPIResourceList(inputMap);
      String outputJson = JSON.encode(resourceList);

      expect(outputJson, equals(inputJson));
    });
  });
}
