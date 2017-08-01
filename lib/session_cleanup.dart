@HtmlImport('session_cleanup.html')
library plato.elements.session.cleanup;

import 'dart:convert' show JSON;
import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_signals.dart';

/// Silence analyzer: [IronSignals]
///
/// The [SessionCleanup] class...
@PolymerRegister('session-cleanup')
class SessionCleanup extends PolymerElement {
  @Property(notify: true)
  bool crfSuccess;

  /// The [SessionCleanup] factory constructor.
  factory SessionCleanup() => document.createElement ('session-cleanup');

  /// The [SessionCleanup] named constructor.
  SessionCleanup.created() : super.created();

  /// The [attached] method...
  void attached() {
    set ('crfSuccess', false);

    window.onUnload.listen ((_) => cleanupSession());
  }

  /// The [onCrfSuccess] method...
  @Listen('iron-signal-crf-success')
  void onCrfSuccess (CustomEvent event, details) {
    set ('crfSucess', true);
  }

  /// The [cleanupSession] method...
  void cleanupSession() {
    if (!crfSuccess) {
      ($['cleanup-session-ajax'] as IronAjax)
        ..contentType = 'application/json'
        ..body = JSON.encode ({'clearSession': true})
        ..generateRequest();
    }
  }

  /// The [onSessionClearedResponse] method...
  @Listen('response')
  void onSessionClearedResponse (CustomEvent event, details) {}
}
