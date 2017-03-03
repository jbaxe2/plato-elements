@HtmlImport('learn_authentication_view.html')
library plato.elements.view.authentication.learn;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/communication_icons.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_material.dart';

import 'learn_authenticator.dart';

/// Silence analyzer:
/// [IronIcon] - [PaperButton] - [PaperInput] - [PaperMaterial]
///
/// The [LearnAuthenticationView] class...
@PolymerRegister('learn-authentication-view')
class LearnAuthenticationView extends PolymerElement {
  @Property(notify: true)
  String username;

  @Property(notify: true)
  String password;

  LearnAuthenticator _learnAuthenticator;

  /// The [LearnAuthenticationView] factory constructor.
  factory LearnAuthenticationView() => document.createElement ('learn-authentication-view');

  /// The [LearnAuthenticationView] named constructor.
  LearnAuthenticationView.created() : super.created();

  /// The [attached] method...
  void attached() {
    _learnAuthenticator = $['learnAuthenticator'] as LearnAuthenticator;
  }

  @Listen('keydown')
  void authLearnByEnter (KeyboardEvent event, details) {
    try {
      if ((13 == event.keyCode) && !(username.isEmpty || password.isEmpty)) {
        _requestAuth();
      }
    } catch (_) {}
  }

  /// The [authenticateLearn] method...
  @Listen('tap')
  void authenticateLearn (CustomEvent event, details) {
    if (username.isEmpty || password.isEmpty) {
      return;
    }

    if ((Polymer.dom (event)).rootTarget is PaperButton) {
      _requestAuth();
    }
  }

  /// The [_requestAuth] method...
  void _requestAuth() {
    _learnAuthenticator
      ..username = username
      ..password = password
      ..performAuthRequest();
  }
}
