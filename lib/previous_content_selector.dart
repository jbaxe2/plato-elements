@HtmlImport('previous_content_selector.html')
library plato.elements.selector.previous_content;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_card.dart';

import 'enrollment_selector.dart';

import 'data_models.dart' show BannerSection, CourseEnrollment, PreviousContentMapping;

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

  /// The current [BannerSection] instance for which previous content will be copied.
  @Property(notify: true)
  BannerSection currentSection;

  @Property(notify: true)
  bool get haveEnrollments => _haveEnrollments;

  bool _haveEnrollments;

  @Property(notify: true)
  bool get isVisible => _isVisible;

  bool _isVisible;

  /// The [PreviousContentSelector] factory constructor.
  factory PreviousContentSelector() => document.createElement ('previous-content-selector');

  /// The [PreviousContentSelector] constructor.
  PreviousContentSelector.created() : super.created() {
    enrollments = new List<CourseEnrollment>();
  }

  /// The [attached] method...
  void attached() {
    notifyPath ('haveEnrollments', _haveEnrollments = false);
    notifyPath ('isVisible', _isVisible = false);
  }

  /// The [enrollmentsComplete] method...
  @Listen('enrollments-complete')
  void enrollmentsComplete (CustomEvent event, detail) =>
    notifyPath ('haveEnrollments', _haveEnrollments = true);

  /// The [onEnrollmentSelected] method...
  @Listen('tap')
  void onEnrollmentSelected (CustomEvent event, detail) {
    if (('enrollmentSelectedButton' == (Polymer.dom (event)).rootTarget.id) &&
        (null != selectedEnrollment)) {
      this.fire ('iron-signal', detail: {
        'name': 'previous-content-specified',
        'data': {
          'section': currentSection,
          'previousContent':
            new PreviousContentMapping()
              ..section = currentSection
              ..courseEnrollment = selectedEnrollment
        }
      });

      notifyPath ('isVisible', _isVisible = false);
      notifyPath ('currentSection', null);
    }
  }

  /// The [onShowCopyContentSelector] method...
  @Listen('iron-signal-show-copy-content-selector')
  void onShowCopyContentSelector (CustomEvent event, detail) {
    if (null != detail['section']) {
      notifyPath ('currentSection', currentSection = (detail['section'] as BannerSection));
      notifyPath ('isVisible', _isVisible = true);
    }
  }
}
