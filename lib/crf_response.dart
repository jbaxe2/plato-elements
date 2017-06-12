@HtmlImport('crf_response.html')
library plato.elements.crf.response;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_material.dart';

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

import 'plato_elements_utils.dart';

/// Silence analyzer:
/// [IronSignals] - [PaperButton] - [PaperMaterial]
/// [FadeInAnimation] - [FadeOutAnimation]
///
/// The [CrfResponse] class...
@PolymerRegister('crf-response')
class CrfResponse extends PolymerElement {
  @Property(notify: true)
  String result;

  @Property(notify: true)
  bool haveRejectedCourses;

  @Property(notify: true)
  List<Map<String, String>> rejectedCourses;

  /// The [CrfResponse] factory constructor.
  factory CrfResponse() => document.createElement ('crf-response');

  /// The [CrfResponse] named constructor.
  CrfResponse.created() : super.created();

  /// The [attached] method...
  void attached() {
    set ('result', 'failure');
    set ('haveRejectedCourses', false);

    set ('rejectedCourses', new List<Map<String, String>>());
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
      set ('result', details['result']);

      async (() {
        add (
          'rejectedCourses', details['rejectedCourses'] as List<Map<String, String>>
        );

        if ('partial success' == result) {
          if (1 > rejectedCourses.length) {
            raiseError (this,
              'Submission response error',
              'The course request submission resulted in a partial success;<br>'
                'however, the response from the server was not able to be processed<br>'
                'successfully to determine what issues arose.'
            );

            return;
          }

          set ('haveRejectedCourses', true);
        }

        ($['crf-response-dialog'] as PaperDialog)
          ..refit()
          ..center()
          ..open();
      });
    } catch (_) {
      raiseError (this,
        'Submission response error',
        'Unable to determine the resposne from the server for the course request<br>'
          'submission.  However, the submission may have processed successfully.'
      );

      return;
    }
  }

  /// The [onCrfResponseConfirmation] method...
  @Listen('tap')
  void onCrfComplete (CustomEvent event, details) {
    if ('crf-complete-button' == (Polymer.dom (event)).rootTarget.id) {
      window.location.replace ('http://www.westfield.ma.edu/plato/');
    }
  }
}
