// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import "package:test/test.dart";
import "package:jsonapi_client/jsonapi_client.dart";

void main() {
  group("test MockJSONAPIClient", () {
    JSONAPIDocument d = new JSONAPIDocument({
      'data': {
        'type': 'persons',
        'id': '1',
        'attributes': {
          'name': 'Gianfranco',
          'surname': 'Reppucci'
        }
      }
    });

    test("client get method returns the input value using setOutput", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      c.setOutput(d);

      JSONAPIDocument expectedDocument = await c.get('http://mockapi.test/persons/1');
      expect(expectedDocument.toJson(), equals(d.toJson()));
    });

    test("client post method returns the input value using setOutput", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      c.setOutput(d);

      Map inputDocument = d.toJson();
      inputDocument['data'].remove('id');

      JSONAPIDocument expectedDocument = await c.post('http://mockapi.test/persons', JSON.encode(inputDocument));
      expect(expectedDocument.toJson(), equals(d.toJson()));
    });

    test("client delete method returns the input value using setOutput", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      c.setOutput(d);

      JSONAPIDocument expectedDocument = await c.delete('http://mockapi.test/persons/1');
      expect(expectedDocument.toJson(), equals(d.toJson()));
    });
  });
}
