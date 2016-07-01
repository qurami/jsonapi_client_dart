// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import "package:test/test.dart";
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import "package:jsonapi_client/jsonapi_client.dart";

Map getMockJSONAPIResourceAsMap() {
  return {
    "data": {
      "type": "persons",
      "id": "1",
      "attributes": {"name": "Gianfranco", "surname": "Reppucci"},
      "relationships": {
        "company": {
          "links": {"related": "http://mockapi.test/companies/qurami"},
          "data": {"type": "companies", "id": "qurami"}
        }
      }
    }
  };
}

var mockHTTPClient = new MockClient((request) {
  if (request.method == 'GET'){
    if (request.url.toString() == "http://mockapi.test/persons/1") {
      return new http.Response(JSON.encode(getMockJSONAPIResourceAsMap()), 200,
          headers: {'content-type': 'application/vnd.api+json'});
    }

    if (request.url.toString().contains('include=')) {
      Map mockObjectWithIncluded = getMockJSONAPIResourceAsMap();
      mockObjectWithIncluded['included'] = [
        {
          "type": "companies",
          "id": "qurami",
          "attributes": {"name": "Qurami"}
        }
      ];
      return new http.Response(JSON.encode(mockObjectWithIncluded), 200,
          headers: {'content-type': 'application/vnd.api+json'});
    }

    if (request.url.toString() == "http://mockapi.test/persons/non-existing") {
      return new http.Response(
          JSON.encode({
            "errors": [
              {"status": "404", "detail": "Object not found"}
            ]
          }),
          404,
          headers: {'content-type': 'application/vnd.api+json'});
    }

    if (request.url.toString() == "http://mockapi.test/broken.url") {
      return new http.Response("Internal server error", 500);
    }
  }

  if ((request.url.toString() == "http://mockapi.test/persons") &&
      (request.method == "POST")) {
    return new http.Response(
        JSON.encode(getMockJSONAPIResourceAsMap()),
        200,
        headers: {'content-type': 'application/vnd.api+json'});
  }

  if ((request.url.toString() == "http://mockapi.test/persons/1") &&
      (request.method == "DELETE")) {
    return new http.Response("", 204);
  }
});

void main() {
  group("test basic behaviour on JSONAPI Client", () {
    test("url is properly set", () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      await c.get("http://mockapi.test/persons/1", includeModels: ["company", "contacts"]);
      expect(c.request.url.toString(), equals("http://mockapi.test/persons/1?include=company,contacts"));

      await c.get("http://mockapi.test/persons/1?key=value", includeModels: ["company"]);
      expect(c.request.url.toString(), equals("http://mockapi.test/persons/1?key=value&include=company"));
    });

    test("headers are properly set", () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      Map fakeAdditionalHeaders = {
        'X-Custom-Header': 'fakeValue'
      };

      await c.get("http://mockapi.test/persons/1", headers: fakeAdditionalHeaders);

      expect(c.request.headers.containsKey('X-Custom-Header'), equals(true));
      expect(c.request.headers['X-Custom-Header'], equals('fakeValue'));
      expect(c.request.headers.containsKey('Accept'), equals(true));
      expect(c.request.headers['Accept'], equals('application/vnd.api+json'));
      expect(c.request.headers.containsKey('Content-Type'), equals(true));
      expect(c.request.headers['Content-Type'], equals('application/vnd.api+json'));
    });
  });

  group("test GET method on JSONAPI Client", () {
    test("GET method with no include and successful response with single item",
        () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      JSONAPIDocument d = await c.get("http://mockapi.test/persons/1");

      expect(c.request.method, equals('GET'));
      expect(d.data is JSONAPIResource, equals(true));
      expect((d.data as JSONAPIResource).id, equals('1'));
      expect(d.included == null, equals(true));
    });

    test(
        "GET method with included model and successful response with single item",
        () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);
      List<String> includedModels = ["company"];

      JSONAPIDocument d = await c.get("http://mockapi.test/persons/1",
          includeModels: includedModels);

      expect(c.request.method, equals('GET'));
      expect(d.data is JSONAPIResource, equals(true));
      expect((d.data as JSONAPIResource).id, equals('1'));
      expect(d.included is JSONAPIResourceList, equals(true));
      expect(d.included.length, equals(1));
      expect((d.included[0] as JSONAPIResource).id, equals('qurami'));
    });

    test("GET method with no include and response with JSONAPIError",
        () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      JSONAPIDocument d =
          await c.get("http://mockapi.test/persons/non-existing");

      expect(c.request.method, equals('GET'));
      expect(d.data == null, equals(true));
      expect(d.errors is JSONAPIErrorList, equals(true));
      expect(d.included == null, equals(true));
    });

    test("GET method with no include and unsuccessful response", () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      var expectedException = null;
      try {
        await c.get("http://mockapi.test/broken.url");
      } catch (e) {
        expectedException = e;
      }

      expect(expectedException != null, equals(true));
    });
  });

  group("test POST method on JSONAPI Client", () {
    test("POST method with successful response", () async {
      Map payload = getMockJSONAPIResourceAsMap();
      payload['data'].remove('id');

      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      JSONAPIDocument d = await c.post('http://mockapi.test/persons', JSON.encode(payload));

      expect(c.request.method, equals('POST'));
      expect(d.data is JSONAPIResource, equals(true));
      expect(JSON.encode(d), equals(JSON.encode(getMockJSONAPIResourceAsMap())));
      expect(d.included == null, equals(true));
    });
  });

  group("test DELETE method on JSONAPI Client", () {
    test("DELETE method with successful response (no data)", () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      var expectedException = null;
      try {
        await c.delete('http://mockapi.test/persons/1');
      } catch(e){
        expectedException = e;
        print(e);
      }

      expect(c.request.method, equals('DELETE'));
      expect(expectedException == null, equals(true));
    });
  });
}
