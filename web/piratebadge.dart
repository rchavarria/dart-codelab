// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:html";
import "dart:math" show Random;
import "dart:convert" show JSON;
import "dart:async" show Future;

final String TREASURE_KEY = 'pirateName';
ButtonElement btnGenerateName;
SpanElement badgeNameElement;

void main() {
  InputElement inputField = querySelector('#inputName');
  inputField.onInput.listen(updateBadge);
  
  btnGenerateName = querySelector('#generateName');
  btnGenerateName.onClick.listen(generateBadge);
  
  badgeNameElement = querySelector('#badgeName');
  
  setBadgeName(getBadgeNameFromStorage());
  
  PirateName.readyThePirates()
      .then((_) {
        //on success
        inputField.disabled = false; //enable
        btnGenerateName.disabled = false;  //enable
        setBadgeName(getBadgeNameFromStorage());
      })
      .catchError((arrr) {
        print('Error initializing pirate names: $arrr');
        badgeNameElement.text = 'Arrr! No names.';
      });
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
  
  static List<String> NAMES = [];
  static List<String> APPELLATIONS = [];
  
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
  

  static Future readyThePirates() {
    var path = 'piratenames.json';
    return HttpRequest.getString(path)
        .then(_parsePirateNamesFromJSON);
  }
  
  static _parsePirateNamesFromJSON(String jsonString) {
    Map pirateNames = JSON.decode(jsonString);
    NAMES = pirateNames['names'];
    APPELLATIONS = pirateNames['appellations'];
  }
  
  String get pirateName =>
      _name.isEmpty ? '' : '$_name the $_appellation';
  
  String get jsonString => 
      JSON.encode( {"f": _name, "a": _appellation} );
}