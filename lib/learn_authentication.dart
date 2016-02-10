@HtmlImport('learn_authentication.html')
library plato_elements.lib.learn_authentication;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:polymer_elements/iron_ajax.dart';

@PolymerRegister('learn-authentication')
class LearnAuthentication extends PolymerElement {
  @Property(notify: true)
  String username;

  @Property(notify: true)
  String password;

  /// The [LearnAuthentication] factory constructor.
  factory LearnAuthentication() => document.createElement ('learn-authentication');

  /// The [LearnAuthentication] constructor.
  LearnAuthentication.created() : super.created();

  void attached() {
    ($['learn-ajax'] as IronAjax).generateRequest();
  }

  @Observe('username, password')
  void handleAuthRequest (String newUsername, String newPassword) {
    ;
  }

  /// The [handleAuthResponse] method...
  void handleAuthResponse() {
    ;
  }
}
