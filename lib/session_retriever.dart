@HtmlImport('session_retriever.html')
library plato.elements.retriever.session;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'simple_retriever.dart';

/// Silence analyzer:  [SimpleRetriever]
///
/// The [SessionRetriever] class...
@PolymerRegister('session-retriever')
class SessionRetriever extends PolymerElement {
  /// The Learn username for the user.
  @Property(notify: true)
  String username;

  @Property(notify: true)
  bool get isLtiSession => _isLtiSession;

  bool _isLtiSession = false;

  /// The [SessionRetriever] factory constructor.
  factory SessionRetriever() => document.createElement ('session-retriever');

  /// The [SessionRetriever] named constructor.
  SessionRetriever.created() : super.created();

  /// The [attached] method...
  void attached() {
    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': {
      'message': 'Determining application startup context.'
    }});

    ($['session-retriever'] as SimpleRetriever).retrieveTypedData();
  }

  /// The [onSessionRetrieved] method...
  @Listen('session-retrieved')
  void onSessionRetrieved (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    if (null != details['session']) {
      try {
        var session = details['session'];

        if ((session['plato.session.exists']) &&
            ('true' == session['learn.user.authenticated'])) {
          set ('username', session['learn.user.username']);
          notifyPath ('isLtiSession', _isLtiSession = true);

          this.fire ('retrieve-user', canBubble: true);
        }
      } catch (_) {}
    }
  }
}
