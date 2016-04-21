@HtmlImport('learn_authentication_view.html')
library plato_elements.learn_authentication_view;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/communication_icons.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_material.dart';

import 'data_models.dart' show UserInformation;

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

  @Property(notify: true)
  UserInformation userInfo;

  /// The [LearnAuthenticationView] factory constructor.
  factory LearnAuthenticationView() => document.createElement ('learn-authentication-view');

  /// The [LearnAuthenticationView] named constructor.
  LearnAuthenticationView.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [retrieveUser] method...
  @Listen('tap')
  void retrieveUser (CustomEvent event, details) {
    if ((Polymer.dom (event)).rootTarget is PaperButton) {
      this.fire (
        'retrieve-user', detail: {'username': username, 'password': password}
      );
    }
  }
}
