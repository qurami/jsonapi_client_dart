// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

abstract class FactoryBuildableObject {
  /// returns a Map of json-to-property bindings
  ///
  /// this method is used to associate a json key to the property name of the
  /// object implementing the interface
  /// There is no need to override this method or return anything if object's property
  /// names are equal to the json value provided.
  Map<String, String> getPropertyBindingMap();

  /// returns an array of json-to-property data validator
  ///
  /// can be used to validate data or to instantiate custom non-json object types
  Map<String, Function> getPropertyValidatorMap();
}
