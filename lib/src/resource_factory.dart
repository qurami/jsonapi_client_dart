// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:mirrors';
import 'factory_buildable_object.dart';
import 'resource.dart';

class JSONAPIResourceFactory {
  Map<String, ClassMirror> typeToClassMap = new Map<String, ClassMirror>();

  /// binds a provided ClassMirror to a JSONAPIResource type
  ///
  /// the [inputClass] gets stored and the used to instantiate
  /// every JSONAPIResource of matching [type]
  ///
  /// Throws an [ArgumentError] if parameters aren't provided.
  void bindClassMirrorToResourceOfType(ClassMirror inputClass, String type) {
    if (inputClass == null || type == null || type.length == 0) {
      throw new ArgumentError('inputClass and type parameters are mandatory');
    }
    typeToClassMap[type] = inputClass;
  }

  /// validates a [jsonapiResourceMap] to check if cointains mandatory fields
  /// for initializing a [JSONAPIResource]
  ///
  /// Throws an [Exception] if [jsonAPIResourceMap] is malformed
  static _validateJSONAPIResourceMap(Map jsonAPIResourceMap) {
    if (!jsonAPIResourceMap.containsKey('id') ||
        !jsonAPIResourceMap.containsKey('type')) {
      throw new Exception("malformed jsonapi resource map passed to factory");
    }
  }

  /// instantiates an object with [jsonAPIResourceMap]
  ///
  /// the object class will be custom if previously bound with [bindClassMirrorToResourceOfType]
  /// or [JSONAPIResource] otherwise.
  instantiateObjectWithJSONAPIResourceMap(Map jsonAPIResourceMap) {
    _validateJSONAPIResourceMap(jsonAPIResourceMap);

    String classType = jsonAPIResourceMap['type'];
    ClassMirror associatedClassMirror = typeToClassMap[classType];

    // if no associated class mirror is found a JSONAPIResource is returned
    if (associatedClassMirror != null) {
      // a subclass corresponding to the passed class mirror gets instantiated
      // and every property gets initialized with the attributes in the jsonAPIMap
      var newResource = associatedClassMirror
          .newInstance(new Symbol(''), [jsonAPIResourceMap]).reflectee;
      if (jsonAPIResourceMap.containsKey('attributes')) {
        Map attributes = jsonAPIResourceMap['attributes'];
        for (String key in attributes.keys) {
          _setJSONAPIResourcePropertyWithValue(
              newResource, key, attributes[key]);
        }
      }

      return newResource;
    } else {
      JSONAPIResource newResource = new JSONAPIResource(jsonAPIResourceMap);
      return newResource;
    }
  }

  /// sets the property of name [key] to the passed [resource]
  /// with the passed [value]. Uses reflection to work on [JSONAPIResource] subclsses.
  ///
  /// throws an [ArgumentError] if no [key] or [resource] are provided (null [value] is accepted instead).
  /// throws an [Exception] if there is no property declared on [resource] for the provided [key].
  static _setJSONAPIResourcePropertyWithValue(
      FactoryBuildableObject resource, String key, value) {
    if (resource == null || key == null) {
      throw new ArgumentError('key and resource parameters are mandatory');
    }
    if (value != null) {
      // checks if there is a custom property binding map provided.
      Map propertyAssociation = resource.getPropertyBindingMap();
      if (propertyAssociation == null) {
        propertyAssociation = {};
      }

      // checks if there is a custom property validator map provided.
      Map propertyValidator = resource.getPropertyValidatorMap();
      if (propertyValidator == null) {
        propertyValidator = {};
      }

      // gets the string corresponding to the property to be set
      // using the one provided on the custom map or the provided key if not present.
      String propertyName = (propertyAssociation.containsKey(key))
          ? propertyAssociation[key]
          : key;

      // gets the value to be set
      // using the one provided one as it is if no validating function is passed.
      var propertyValue = (propertyValidator.containsKey(key))
          ? propertyValidator[key](value)
          : value;

      //sets the property
      InstanceMirror reflectableInstance = reflect(resource);
      Symbol property = new Symbol(propertyName);
      if (MirrorSystem.getName(property) != null) {
        reflectableInstance.setField(property, propertyValue);
      } else {
        throw new Exception(
            'jsonapi resource subclass has no property of key' + key);
      }
    }
  }
}
