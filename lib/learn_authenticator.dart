@HtmlImport('learn_authenticator.html')
library plato_elements.learn_authenticator;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

/// The [LearnAuthenticator] element is a simple custom element that attempts
/// to authenticate against a Blackboard Learn 9.1 instance using a username and
/// password pair, configurable on the element.
@PolymerRegister('learn-authenticator')
class LearnAuthenticator extends PolymerElement {
  /// The Blackboard Learn username.
  @Property(notify: true)
  String username;

  /// The Blackboard Learn password.
  @Property(notify: true)
  String password;

  /// The result of the authentication attempt; read-only.
  @property
  bool get result => _result;

  bool _result;

  /// The [IronAjax] instance for authenticating against the Learn server.
  IronAjax _learnAuthAjax;

  /// The [LearnAuthenticator] factory constructor.
  factory LearnAuthenticator() => document.createElement ('learn-authenticator');

  /// The [LearnAuthenticator] constructor.
  LearnAuthenticator.created() : super.created();

  /// The [attached] method...
  void attached() {
    if (('' != username) && ('' != password)) {
      performAuthRequest();
    }
  }

  /// The [handleUserPassChanged] method listens for changes to both the username
  /// and password properties, and once both updated will attempt authentication.
  @Observe('username, password')
  void handleUserPassChanged (String newUsername, String newPassword) {
    performAuthRequest();
  }

  /// The [performAuthRequest] method invokes the [IronAjax] element to generate
  /// and perform an authentication request for Blackboard Learn.
  void performAuthRequest() {
    _learnAuthAjax ??= $['learn-auth-ajax'] as IronAjax;

    // If a request is loading, we're already attempting to authenticate.
    if (_learnAuthAjax.loading) {
      return;
    }

    _learnAuthAjax
      ..contentType = 'application/x-www-form-urlencoded'
      ..body = {
          'username': username,
          'password': password
        }
      ..generateRequest();
  }

  /// The [handleAuthResponse] method...
  @Listen('response')
  void handleAuthResponse (event, details) {
    var response = _learnAuthAjax.lastResponse;

    if (null != response['authResult']) {
      _result = response['authResult'];
    } else {
      _result = false;
    }

    notifyPath ('result', _result);
  }
}
