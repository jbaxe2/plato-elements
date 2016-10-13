@HtmlImport('previous_content_selector.html')
library plato.elements.selector.previous_content;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_card.dart';

import 'enrollment_selector.dart';

import 'data_models.dart' show CourseEnrollment;

/// Silence analyzer:
/// [PaperButton] - [PaperCard] - [IronSignals] - [EnrollmentSelector]
///
/// The [PreviousContentSelector] element class...
@PolymerRegister('previous-content-selector')
class PreviousContentSelector extends PolymerElement {
  /// The [List] of [CourseEnrollment] instances.
  @Property(notify: true)
  List<CourseEnrollment> enrollments;

  /// The [CourseEnrollment] instance representing the selected enrollment.
  @Property(notify: true)
  CourseEnrollment selectedEnrollment;

  @Property(notify: true)
  bool get haveEnrollments => _haveEnrollments;

  bool _haveEnrollments = false;

  @Property(notify: true)
  bool get isVisible => _isVisible;

  bool _isVisible = false;

  /// The [PreviousContentSelector] factory constructor.
  factory PreviousContentSelector() => document.createElement ('previous-content-selector');

  /// The [PreviousContentSelector] constructor.
  PreviousContentSelector.created() : super.created() {
    enrollments = new List<CourseEnrollment>();
  }

  /// The [attached] method...
  void attached();

  /// The [enrollmentsComplete] method...
  @Listen('enrollments-complete')
  void enrollmentsComplete (CustomEvent event, detail) =>
    notifyPath ('haveEnrollments', _haveEnrollments = true);

  /// The [onEnrollmentSelected] method...
  @Listen('enrollment-selected')
  void onEnrollmentSelected (CustomEvent event, detail) {
    window.console.debug ('an enrollment has been selected');
    window.console.debug (selectedEnrollment);

    notifyPath ('isVisible', _isVisible = false);
  }

  /// The [onShowCopyContentSelector] method...
  @Listen('iron-signal-show-copy-content-selector')
  void onShowCopyContentSelector (CustomEvent event, detail) {
    if (null != detail['section']) {
      notifyPath ('isVisible', _isVisible = true);
    }
  }
}
