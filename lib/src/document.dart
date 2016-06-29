// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

/// Dartlang representation of a JSON API Document object.
/// Conforms to the JsonApi 1.0 specification.
/// For any further information please visit http://jsonapi.org
class JSONAPIDocument {
  /// The meta object of the JSON API Document.
  Object meta;

  /// The data object of the JSON API Document.
  /// This member is mandatory by jsonapi specification. This object, by jsonapi
  /// design, can be either an Array or a Resource, therefore the type is
  /// intentionally generic. It will always be initialized as a Resource or as a
  /// List of Resource instances.
  Object data;

  /// The errors array of the JSON API Document, empty if no errors have been
  /// received.
  /// This member is mandatory by JSON API specification.
  List<Object> errors;

  /// The links object of the JSON API Document.
  /// This member is optional by JSON API specification.
  List<Object> links;

  /// The included resources array of the JSON API Document.
  // If any resource has been included, it's stored in this array following
  // jsonapi specification, otherwise this array is empty.
  List<Object> included;

  JSONAPIDocument(Map dictionary) {
    if ((!dictionary.containsKey('data')) &&
        (!dictionary.containsKey('errors'))) {
      throw new FormatException("Missing data");
    }

    if (dictionary.containsKey('data')) {
      data = dictionary['data'];
    }

    if (dictionary.containsKey('errors')) {
      errors = dictionary['errors'];
    }

    if (dictionary.containsKey('meta')) {
      meta = dictionary['meta'];
    }

    if (dictionary.containsKey('links')) {
      links = dictionary['links'];
    }

    if (dictionary.containsKey('included')) {
      included = dictionary['included'];
    }
  }

  Map toJson() {
    Map map = new Map();

    if (data != null) {
      map['data'] = JSON.decode(JSON.encode(data));
    }

    if (errors != null) {
      map['errors'] = JSON.decode(JSON.encode(errors));
    }

    if (meta != null) {
      map['meta'] = JSON.decode(JSON.encode(meta));
    }

    if (links != null) {
      map['links'] = JSON.decode(JSON.encode(links));
    }

    if (included != null) {
      map['included'] = JSON.decode(JSON.encode(included));
    }

    return map;
  }
}
