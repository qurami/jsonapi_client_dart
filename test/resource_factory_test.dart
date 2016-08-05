@Timeout(const Duration(seconds: 600))
import 'package:test/test.dart';
import 'dart:mirrors';
import 'package:jsonapi_client/jsonapi_client.dart';

//TODO: Remove
import 'package:jsonapi_client/src/factory_buildable_object.dart';

class MockClass extends JSONAPIResource with FactoryBuildableObject {
  String standardStringAttribute;
  Map standardMapAttribute;
  int standardIntAttribute;
  String propertyWithDifferentName;
  String propertyThatGetsProcessedByValidator;

  MockClass(Map jsonMap) : super(jsonMap);

  getPropertyBindingMap() {
    return {"propertyWithJsonName": "propertyWithDifferentName"};
  }

  getPropertyValidatorMap() {
    return {
      "propertyThatGetsProcessedByValidator": (String value) {
        return value + " addition";
      }
    };
  }
}

void main() {
  JSONAPIResourceFactory sut;
  setUp(() {
    sut = new JSONAPIResourceFactory();
  });

  tearDown(() {
    sut = null;
  });

  test("test that class mirror gets associated", () {
    ClassMirror cm = reflectClass(MockClass);
    sut.bindClassMirrorToResourceOfType(cm, 'mock-type');
    expect(sut.typeToClassMap['mock-type'], equals(cm));
  });

  test("test that throws if no class mirror is provided", () {
    ArgumentError expectedException = null;
    try {
      sut.bindClassMirrorToResourceOfType(null, 'mock-type');
    } catch (e) {
      expectedException = e;
    }
    expect(expectedException, isNotNull);
  });

  test("test that throws if no type is provided", () {
    ClassMirror cm = reflectClass(MockClass);
    ArgumentError expectedException = null;
    try {
      sut.bindClassMirrorToResourceOfType(cm, null);
    } catch (e) {
      expectedException = e;
    }
    expect(expectedException, isNotNull);
  });

  test("test that throws if type provided is zero length", () {
    ClassMirror cm = reflectClass(MockClass);
    ArgumentError expectedException = null;
    try {
      sut.bindClassMirrorToResourceOfType(cm, '');
    } catch (e) {
      expectedException = e;
    }
    expect(expectedException, isNotNull);
  });

  test("test that sut throws if jsonapi map is malformed", () {
    ClassMirror cm = reflectClass(MockClass);
    sut.bindClassMirrorToResourceOfType(cm, 'mock-type');
    Map malformedMap = {"malformation": "isBad"};
    Exception expectedException = null;
    try {
      sut.instantiateObjectWithJSONAPIResourceMap(malformedMap);
    } catch (e) {
      expectedException = e;
    }
    expect(expectedException, isNotNull);
  });

  test(
      "test that sut returns a JSONAPIResource if no associated class is found",
      () {
    Map mockMap = {"id": "1234", "type": "mock-type"};
    var returnedObject = sut.instantiateObjectWithJSONAPIResourceMap(mockMap);
    expect((returnedObject is JSONAPIResource), isTrue);
  });

  test("test that sut returns object with right class", () {
    ClassMirror cm = reflectClass(MockClass);
    sut.bindClassMirrorToResourceOfType(cm, 'mock-type');
    Map mockMap = {"id": "1234", "type": "mock-type"};
    var returnedObject = sut.instantiateObjectWithJSONAPIResourceMap(mockMap);
    expect(returnedObject is MockClass, isTrue);
  });

  test("test that sut initalizes object with default properties", () {
    ClassMirror cm = reflectClass(MockClass);
    sut.bindClassMirrorToResourceOfType(cm, 'mock-type');
    Map mockMap = {"id": "1234", "type": "mock-type"};
    JSONAPIResource returnedObject =
        sut.instantiateObjectWithJSONAPIResourceMap(mockMap);
    expect(returnedObject.id, equals('1234'));
    expect(returnedObject.type, equals('mock-type'));
  });

  test("test that sut initalizes object with attribute properties", () {
    ClassMirror cm = reflectClass(MockClass);
    sut.bindClassMirrorToResourceOfType(cm, 'mock-type');
    Map mockMap = {
      "id": "1234",
      "type": "mock-type",
      "attributes": {
        "standardStringAttribute": "mockString",
        "standardMapAttribute": {"one": 1, "two": "2"},
        "standardIntAttribute": 3
      }
    };

    MockClass returnedObject =
        sut.instantiateObjectWithJSONAPIResourceMap(mockMap);
    expect(returnedObject.standardStringAttribute, equals('mockString'));
    expect(returnedObject.standardMapAttribute, equals({"one": 1, "two": "2"}));
    expect(returnedObject.standardIntAttribute, equals(3));
  });

  test(
      "test that sut initalizes object with attribute properties in association map",
      () {
    ClassMirror cm = reflectClass(MockClass);
    sut.bindClassMirrorToResourceOfType(cm, 'mock-type');
    Map mockMap = {
      "id": "1234",
      "type": "mock-type",
      "attributes": {
        "standardStringAttribute": "mockString",
        "standardMapAttribute": {"one": 1, "two": "2"},
        "standardIntAttribute": 3,
        "propertyWithJsonName": "they are different but they love each other"
      }
    };

    MockClass returnedObject =
        sut.instantiateObjectWithJSONAPIResourceMap(mockMap);
    expect(returnedObject.propertyWithDifferentName,
        equals('they are different but they love each other'));
  });

  test(
      "test that sut initalizes object with attribute properties in validator map",
      () {
    ClassMirror cm = reflectClass(MockClass);
    sut.bindClassMirrorToResourceOfType(cm, 'mock-type');
    Map mockMap = {
      "id": "1234",
      "type": "mock-type",
      "attributes": {
        "standardStringAttribute": "mockString",
        "standardMapAttribute": {"one": 1, "two": "2"},
        "standardIntAttribute": 3,
        "propertyWithJsonName": "they are different but they love each other",
        "propertyThatGetsProcessedByValidator": "expecting"
      }
    };

    MockClass returnedObject =
        sut.instantiateObjectWithJSONAPIResourceMap(mockMap);
    expect(returnedObject.propertyThatGetsProcessedByValidator,
        equals('expecting addition'));
  });
}
