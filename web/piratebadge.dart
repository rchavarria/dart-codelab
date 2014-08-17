// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:html";
import "dart:math" show Random;
import "dart:convert" show JSON;

final String TREASURE_KEY = 'pirateName';
ButtonElement btnGenerateName;

void main() {
  querySelector('#inputName').onInput.listen(updateBadge);
  
  btnGenerateName = querySelector('#generateName');
  btnGenerateName.onClick.listen(generateBadge);
  
  setBadgeName(getBadgeNameFromStorage());
}

void updateBadge(Event e) {
  String newName = (e.target as InputElement).value;
  setBadgeName(new PirateName(firstName: newName));
  
  if(newName.trim().isEmpty) {
    btnGenerateName..disabled = false
                   ..text = 'Aye! Gimme a name!';
  } else {
    btnGenerateName..disabled = true
                   ..text = 'Write yer name';
  }
}

void generateBadge(MouseEvent event) {
  setBadgeName(new PirateName());
}

void setBadgeName(PirateName newName) {
  if (newName == null) {
    return;
  }
  
  querySelector('#badgeName').text = newName.pirateName;
  window.localStorage[TREASURE_KEY] = newName.jsonString;
}

PirateName getBadgeNameFromStorage() {
  String storedName = window.localStorage[TREASURE_KEY];
  if (storedName != null) {
    return new PirateName.fromJSON(storedName);
  } else {
    return null;
  }
}

class PirateName {
  static final Random generator = new Random();
  
  static final List NAMES = [
    'Anne', 'Mary', 'Jack', 'Morgan', 'Roger',
    'Bill', 'Ragnar', 'Ed', 'John', 'Jane' ];
  static final List APPELLATIONS = [
    'Jackal', 'King', 'Red', 'Stalwart', 'Axe',
    'Young', 'Brave', 'Eager', 'Wily', 'Zesty'];
  
  String _name;
  String _appellation;

  PirateName({String firstName, String appellation}) {
    if (firstName == null) {
      _name = NAMES[generator.nextInt(NAMES.length)];
    } else {
      _name = firstName;
    }

    if (appellation == null) {
      _appellation = APPELLATIONS[generator.nextInt(APPELLATIONS.length)];
    } else {
      _appellation = appellation;
    }
  }

  PirateName.fromJSON(String jsonString) {
    Map storedName = JSON.decode(jsonString);
    _name = storedName['f'];
    _appellation = storedName['a'];
  }
  
  String get pirateName =>
      _name.isEmpty ? '' : '$_name the $_appellation';
  
  String get jsonString => 
      JSON.encode( {"f": _name, "a": _appellation} );
}