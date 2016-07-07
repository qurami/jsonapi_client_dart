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

    test("client get method sets proper debug request parameters", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      await c.get('http://mockapi.test/persons/1', includeModels: ['company'], headers: {'X-Test': 'Mock-Value'});
      expect(c.requestUrl, equals('http://mockapi.test/persons/1'));
      expect(c.requestPayload, equals(null));
      expect(c.requestIncludedModels.length, equals(1));
      expect(c.requestIncludedModels[0], equals('company'));
      expect(c.requestHeaders['X-Test'], equals('Mock-Value'));
    });

    test("client post method returns the input value using setOutput", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      c.setOutput(d);

      Map inputDocument = d.toJson();
      inputDocument['data'].remove('id');

      JSONAPIDocument expectedDocument = await c.post('http://mockapi.test/persons', JSON.encode(inputDocument));
      expect(expectedDocument.toJson(), equals(d.toJson()));
    });

    test("client post method sets proper debug request parameters", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      Map inputDocument = d.toJson();
      inputDocument['data'].remove('id');

      await c.post('http://mockapi.test/persons', JSON.encode(inputDocument), includeModels: ['company'], headers: {'X-Test': 'Mock-Value'});

      expect(c.requestUrl, equals('http://mockapi.test/persons'));
      expect(c.requestPayload, JSON.encode(inputDocument));
      expect(c.requestIncludedModels.length, equals(1));
      expect(c.requestIncludedModels[0], equals('company'));
      expect(c.requestHeaders['X-Test'], equals('Mock-Value'));
    });

    test("client delete method returns the input value using setOutput", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      c.setOutput(d);

      JSONAPIDocument expectedDocument = await c.delete('http://mockapi.test/persons/1');
      expect(expectedDocument.toJson(), equals(d.toJson()));
    });

    test("client delete method sets proper debug request parameters", () async {
      MockJSONAPIClient c = new MockJSONAPIClient();

      await c.delete('http://mockapi.test/persons/1', headers: {'X-Test': 'Mock-Value'});
      expect(c.requestUrl, 'http://mockapi.test/persons/1');
      expect(c.requestHeaders['X-Test'], 'Mock-Value');
    });
  });
}
