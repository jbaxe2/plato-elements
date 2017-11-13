@HtmlImport('learn_authenticator.html')
library plato.elements.authenticator.learn;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

import 'plato_elements_utils.dart';

/// The [LearnAuthenticator] element class defines a simple custom element used
/// to attempts authentication against a Blackboard Learn 9.1 instance using a
/// username and password pair, configurable on the element.
@PolymerRegister('learn-authenticator')
class LearnAuthenticator extends PolymerElement {
  /// The Blackboard Learn username.
  @Property(notify: true)
  String username;

  /// The Blackboard Learn password.
  @Property(notify: true)
  String password;

  /// The result of the authentication attempt; read-only.
  @Property(notify: true)
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
    _result = false;

    if (('' != username) && ('' != password)) {
      performAuthRequest();
    }
  }

  /// The [performAuthRequest] method invokes the [IronAjax] element to generate
  /// and perform an authentication request for Blackboard Learn.
  void performAuthRequest() {
    _learnAuthAjax ??= $['learn-auth-ajax'] as IronAjax;

    // If a request is loading, we're already attempting to authenticate.
    if (_learnAuthAjax.loading) {
      return;
    }

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': {
      'message': 'Please wait while we confirm your Plato credentials.'
    }});

    try {
      _learnAuthAjax
        ..method = 'POST'
        ..contentType = 'application/x-www-form-urlencoded'
        ..body = {
            'username': username, 'password': password
          }
        ..generateRequest();
    } catch (_) {}
  }

  /// The [onAuthenticationResponse] method...
  @Listen('response')
  void onAuthenticationResponse (event, details) {
    var response = _learnAuthAjax.lastResponse;

    if (null != response['error']) {
      raiseError (this, 'Authentication error', response['error']);
    } else if (null != response['learn.user.authenticated']) {
      notifyPath ('result', _result = response['learn.user.authenticated']);

      if (_result) {
        this.fire ('retrieve-user', canBubble: true);
      }
    }

    if (!_result) {
      this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

      raiseError (this, 'Authentication error', 'Invalid username or password.');
    }
  }
}
