// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:html";

ButtonElement btnGenerateName;

void main() {
  querySelector('#inputName').onInput.listen(updateBadge);
  
  btnGenerateName = querySelector('#generateName');
  btnGenerateName.onClick.listen(generateBadge);
}

void updateBadge(Event e) {
  String newName = (e.target as InputElement).value;
  setBadgeName(newName);
  
  if(newName.trim().isEmpty) {
    btnGenerateName..disabled = false
                   ..text = 'Aye! Gimme a name!';
  } else {
    btnGenerateName..disabled = true
                   ..text = 'Write yer name';
  }
}

void generateBadge(MouseEvent event) {
  setBadgeName('Anne Bonney');
}

void setBadgeName(String newName) {
  querySelector('#badgeName').text = newName;
}
