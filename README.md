[![CircleCI](https://circleci.com/gh/qurami/jsonapi_client_dart.svg?style=svg)](https://circleci.com/gh/qurami/jsonapi_client_dart)

# JSON API Client in Dartlang

Dartlang implementation of JSON API Client, adherent to [JSON API](http://jsonapi.org) specification 1.0.

## Installation

Add `jsonapi_client` to your pubspec.yaml:

```
dependencies:
  jsonapi_client: "0.0.1"
```


## Usage

Instantiate a client:

```
JSONAPIClient c = new JSONAPIClient();
```

then use it:

```
try {
  JSONAPIDocument d = await c.get(
      'http://api.url/aModel/1',
      includeModels:['anotherModel']);
} catch (err) {
  // the API did not return a valid JSON API Document
}
```

### GET method

Used to retrieve a document containing a JSON API resource or a list of resources.

`Future<JSONAPIDocument> get(String url, {List<String> includeModels, Map headers})`


### POST method

Used to create a document containing a JSON API resource.

`Future<JSONAPIDocument> post(String url, String document, {List<String> includeModels, Map headers})`


### DELETE method

Used to delete a resource.

`Future delete(String url, {Map headers})`


## Tests

You can test your application which uses JSONAPIClient by using the included `MockJSONAPIClient` class.

```
MockJSONAPIClient mockClient = new MockJSONAPIClient();

JSONAPIDocument mockDocument = new JSONAPIDocument({
  "data": {
      "id": "1",
      "type": "persons",
      "attributes": {
        "name": "Gianfranco",
        "surname": "Reppucci"
      }
    }
});

payload = '''
{
  "data": {
      "type": "persons",
      "attributes": {
        "name": "Gianfranco",
        "surname": "Reppucci"
      }
    }
}
''';

mockClient.setOutput(mockDocument);

mockClient.post('http://mockapi.test/persons', payload, includeModels: ['company'], headers: {'X-Test': 'Mock-Value'}); // will return mockDocument as output

// you can access the last request by using these mock client getters
mockClient.requestUrl
mockClient.requestPayload
mockClient.requestIncludedModels
mockClient.requestHeaders
```
