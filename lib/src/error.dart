// Copyright (c) 2016, Qurami team.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:collection';

class JSONAPIError {
  /// The id of the JSON API Error.
  String id;

  /// The status of the JSON API Error.
  String status;

  /// The code of the JSON API Error.
  String code;

  /// The title of the JSON API Error.
  String title;

  /// The details of the JSON API Error.
  String detail;

  /// The links object of the JSON API Error.
  Map links;

  /// The source object of the JSON API Error.
  Map source;

  /// The meta object the JSON API Error.
  Map meta;

  JSONAPIError(Map dictionary) {
    if (dictionary.containsKey('id')) {
      id = dictionary['id'];
    }

    if (dictionary.containsKey('status')) {
      status = dictionary['status'];
    }

    if (dictionary.containsKey('code')) {
      code = dictionary['code'];
    }

    if (dictionary.containsKey('title')) {
      title = dictionary['title'];
    }

    if (dictionary.containsKey('detail')) {
      detail = dictionary['detail'];
    }

    if (dictionary.containsKey('links')) {
      links = dictionary['links'];
    }

    if (dictionary.containsKey('source')) {
      source = dictionary['source'];
    }

    if (dictionary.containsKey('meta')) {
      meta = dictionary['meta'];
    }
  }

  Map toJson() {
    Map map = new Map();

    if (id != null) {
      map['id'] = id;
    }

    if (status != null) {
      map['status'] = status;
    }

    if (code != null) {
      map['code'] = code;
    }

    if (title != null) {
      map['title'] = title;
    }

    if (detail != null) {
      map['detail'] = detail;
    }

    if (links != null) {
      map['links'] = links;
    }

    if (source != null) {
      map['source'] = source;
    }

    if (meta != null) {
      map['meta'] = meta;
    }

    return map;
  }
}

class JSONAPIErrorList extends ListBase{
  final List<JSONAPIError> l = [];

  JSONAPIErrorList(List<Map> data){
    for(Map dictionary in data){
      l.add(new JSONAPIError(dictionary));
    }
  }

  void set length(int newLength) { l.length = newLength; }
  int get length => l.length;
  JSONAPIError operator [](int index) => l[index];
  void operator []=(int index, JSONAPIError value) { l[index] = value; }

  List<Map> toJson() {
    List<Map> mapList = new List<Map>();

    for (JSONAPIError error in l) {
      mapList.add(error.toJson());
    }

    return mapList;
  }
}
