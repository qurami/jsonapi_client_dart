// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import "package:test/test.dart";
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import "package:jsonapi_client/jsonapi_client.dart";

var mockHTTPClient = new MockClient((request) {
  if (request.url.toString() == "http://mockapi.test/persons/1") {
    return new http.Response(
        JSON.encode({
          "data": {
            "type": "persons",
            "id": "1",
            "attributes": {"name": "Gianfranco", "surname": "Reppucci"},
            "relationships": {
              "organization": {
                "links": {
                  "related": "http://mockapi.test/organizations/qurami"
                },
                "data": {"type": "organizations", "id": "qurami"}
              }
            }
          }
        }),
        200,
        headers: {'content-type': 'application/vnd.api+json'});
  }

  if (request.url.toString() ==
      "http://mockapi.test/persons/1?include=organization") {
    return new http.Response(
        JSON.encode({
          "data": {
            "type": "persons",
            "id": "1",
            "attributes": {"name": "Gianfranco", "surname": "Reppucci"},
            "relationships": {
              "organization": {
                "links": {
                  "related": "http://mockapi.test/organizations/qurami"
                },
                "data": {"type": "organizations", "id": "qurami"}
              }
            }
          },
          "included": [
            {
              "type": "organizations",
              "id": "qurami",
              "attributes": {"name": "Qurami"}
            }
          ]
        }),
        200,
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
    return new http.Response(
        "Internal server error",
        500);
  }
});

void main() {
  group("test JSONAPI Client", () {
    test("GET method with no include and successful response with single item",
        () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      JSONAPIDocument d = await c.get("http://mockapi.test/persons/1");
      expect(d.data is JSONAPIResource, equals(true));
      expect((d.data as JSONAPIResource).id, equals('1'));
      expect(d.included == null, equals(true));
    });

    test(
        "GET method with included model and successful response with single item",
        () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);
      List<String> includedModels = ["organization"];

      JSONAPIDocument d = await c.get("http://mockapi.test/persons/1",
          includeModels: includedModels);
      expect(d.data is JSONAPIResource, equals(true));
      expect((d.data as JSONAPIResource).id, equals('1'));
      expect(d.included is JSONAPIResourceList, equals(true));
      expect(d.included.length, equals(1));
      expect((d.included[0] as JSONAPIResource).id, equals('qurami'));
    });

    test("GET method with no include and successful response with JSONAPIError",
        () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      JSONAPIDocument d =
          await c.get("http://mockapi.test/persons/non-existing");
      expect(d.data == null, equals(true));
      expect(d.errors is JSONAPIErrorList, equals(true));
      expect(d.included == null, equals(true));
    });

    test("GET method with no include and unsuccessful response",
        () async {
      JSONAPIClient c = new JSONAPIClient(httpClient: mockHTTPClient);

      var expectedException = null;
      try {
        await c.get("http://mockapi.test/broken.url");
      } catch (e){
        expectedException = e;
      }

      expect(expectedException != null, equals(true));
    });
  });
}
