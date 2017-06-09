@HtmlImport('crf_response.html')
library plato.elements.crf.response;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'plato_elements_utils.dart';

/// Silence analyzer: [IronSignals]
///
/// The [CrfResponse] class...
@PolymerRegister('crf-response')
class CrfResponse extends PolymerElement {
  @Property(notify: true)
  String result;

  @Property(notify: true)
  bool partialSuccess;

  @Property(notify: true)
  List<Map<String, String>> rejectedCourses;

  /// The [CrfResponse] factory constructor.
  factory CrfResponse() => document.createElement ('crf-response');

  /// The [CrfResponse] named constructor.
  CrfResponse.created() : super.created();

  /// The [attached] method...
  void attached() {
    result = 'failure';
    partialSuccess = false;

    rejectedCourses = new List<Map<String, String>>();
  }

  /// The [onCrfResponse] method...
  @Listen('iron-signal-crf-response')
  void onCrfResponse (CustomEvent event, details) {
    if ((null == details['result']) && (null == details['rejectedCourses'])) {
      raiseError (this,
        'Submission response error',
        'No course request has been submitted for receiving a response from.'
      );

      return;
    }

    try {
      ;
    } catch (_) {
      ;
    }
  }
}
