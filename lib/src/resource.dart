// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:collection';

/// Dartlang representation of a JSON API Document object.
/// Conforms to the JsonApi 1.0 specification.
/// For any further information please visit http://jsonapi.org
class JSONAPIResource {
  /// The id of the JSON API Resource.
  /// The id is not required when the resource object originates at the
  /// client and represents a new resource to be created on the server.
  String _id;
  String get id => _id;

  /// The type of the JSON API Resource
  String _type;
  String get type => _type;

  /// The attributes of the JSON API Resource, represented as a Map.
  Map _attributes;
  Map get attributes => _attributes;

  /// The links of the JSON API Resource, represented as a Map.
  Map _links; // @TODO: change to JSONAPILinkList?
  Map get links => _links;

  /// The relationships of the JSON API Resource, represented as a Map.
  Map _relationships; // @TODO: change to JSONAPIRelationshipList?
  Map get relationships => _relationships;

  JSONAPIResource(Map dictionary) {
    if (!dictionary.containsKey('type')) {
      throw new FormatException("Missing type");
    }

    _type = dictionary['type'];

    if (dictionary.containsKey('id')) {
      _id = dictionary['id'];
    }

    if (dictionary.containsKey('attributes')) {
      _attributes = dictionary['attributes'];
    }

    if (dictionary.containsKey('links')) {
      _links = dictionary['links'];
    }

    if (dictionary.containsKey('relationships')) {
      _relationships = dictionary['relationships'];
    }
  }

  Map toJson() {
    Map map = new Map();

    map['type'] = type;

    if (id != null) {
      map['id'] = id;
    }

    if (attributes != null) {
      map['attributes'] = attributes;
    }

    if (links != null) {
      map['links'] = links;
    }

    if (relationships != null) {
      map['relationships'] = relationships;
    }

    return map;
  }
}

class JSONAPIResourceList extends ListBase{
  final List<JSONAPIResource> l = [];

  JSONAPIResourceList(List<Map> data){
    for(Map dictionary in data){
      l.add(new JSONAPIResource(dictionary));
    }
  }

  void set length(int newLength) { l.length = newLength; }
  int get length => l.length;
  JSONAPIResource operator [](int index) => l[index];
  void operator []=(int index, JSONAPIResource value) { l[index] = value; }

  List<Map> toJson() {
    List<Map> mapList = new List<Map>();

    for (JSONAPIResource resource in l) {
      mapList.add(resource.toJson());
    }

    return mapList;
  }
}
