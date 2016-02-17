@HtmlImport('learn_authentication.html')
library plato_elements.lib.learn_authentication;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

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
  LearnAuthentication.created() : super.created() {
    window.alert ('got to create the "learn-authentication" element');
  }

  /// The [attached] method...
  void attached() {
    window.alert ('got to attach the "learn-authentication" element');

    if ('' != username && '' != password) {
      performAuthRequest();
    }
  }

  /// The [handleAuthRequest] method...
  @Observe('username, password')
  void handleAuthRequest (String newUsername, String newPassword) {
    performAuthRequest();
  }

  /// The [performAuthRequest] method...
  void performAuthRequest() {
    window.alert ('got to perform auth request in the "learn-authentication" element');
    ($['learn-auth-ajax'] as IronAjax).generateRequest();
  }

  /// The [handleAuthResponse] method...
  void handleAuthResponse() {
    ;
  }
}
