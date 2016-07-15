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

import 'data_models.dart' show UserInformation;

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

  @Property(notify: true)
  UserInformation userInfo;

  /// The [LearnAuthenticationView] factory constructor.
  factory LearnAuthenticationView() => document.createElement ('learn-authentication-view');

  /// The [LearnAuthenticationView] named constructor.
  LearnAuthenticationView.created() : super.created();

  /// The [attached] method...
  void attached() {
    _learnAuthenticator = new LearnAuthenticator();
  }

  /// The [authenticateLearn] method...
  @Listen('tap')
  void authenticateLearn (CustomEvent event, details) {
    if (('' == username) || ('' == password)) {
      return;
    }

    if ((Polymer.dom (event)).rootTarget is PaperButton) {
      _learnAuthenticator
        ..username = username
        ..password = password
        ..performAuthRequest();

      //this.fire (
      //  'authenticate-learn', detail: {'username': username, 'password': password}
      //);
    }
  }
}
