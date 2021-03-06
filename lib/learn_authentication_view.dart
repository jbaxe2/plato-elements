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

import 'plato_elements_utils.dart';

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
    _learnAuthenticator = $['learn-authenticator'] as LearnAuthenticator;
  }

  /// The [authLearnByEnter] method...
  @Listen('keypress')
  void authLearnByEnter (CustomEventWrapper event, details) {
    try {
      KeyboardEvent keyEvent = event.original;

      if (13 == keyEvent.keyCode) {
        _requestAuth();
      }
    } catch (_) {}
  }

  /// The [authenticateLearn] method...
  @Listen('tap')
  void authenticateLearn (CustomEvent event, details) {
    if ((Polymer.dom (event)).rootTarget is PaperButton) {
      _requestAuth();
    }
  }

  /// The [_requestAuth] method...
  void _requestAuth() {
    if (username.isEmpty || password.isEmpty) {
      raiseError (this,
        'Invalid authentication warning',
        'Please enter both your Plato username and password to authenticate properly.'
      );

      return;
    }

    _learnAuthenticator
      ..username = username
      ..password = password
      ..performAuthRequest();
  }
}
