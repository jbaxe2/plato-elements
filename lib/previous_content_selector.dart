@HtmlImport('previous_content_selector.html')
library plato.elements.selector.previous_content;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_material.dart';

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

import 'enrollment_selector.dart';

import 'data_models.dart' show BannerSection, CourseEnrollment, PreviousContentMapping;

/// Silence analyzer:
/// [IronSignals] - [PaperButton] - [PaperDialogScrollable] - [PaperMaterial]
/// [FadeInAnimation] - [FadeOutAnimation]
///
/// [EnrollmentSelector]
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

  PaperDialog _previousContentDialog;

  /// The [PreviousContentSelector] factory constructor.
  factory PreviousContentSelector() => document.createElement ('previous-content-selector');

  /// The [PreviousContentSelector] constructor.
  PreviousContentSelector.created() : super.created() {
    set ('enrollments', new List<CourseEnrollment>());
  }

  /// The [attached] method...
  void attached() {
    notifyPath ('haveEnrollments', _haveEnrollments = false);

    _previousContentDialog = $['previous-content-dialog'] as PaperDialog;
  }

  /// The [enrollmentsComplete] method...
  @Listen('enrollments-complete')
  void enrollmentsComplete (CustomEvent event, detail) =>
    notifyPath ('haveEnrollments', _haveEnrollments = true);

  /// The [onShowCopyContentSelector] method...
  @Listen('iron-signal-show-copy-content-selector')
  void onShowCopyContentSelector (CustomEvent event, detail) {
    if (enrollments.isEmpty) {
      return;
    }

    if (null != detail['section']) {
      set ('currentSection', (detail['section'] as BannerSection));

      _previousContentDialog
        ..refit()
        ..center()
        ..open();
    }
  }

  /// The [onEnrollmentSelected] method...
  @Listen('tap')
  void onEnrollmentSelected (CustomEvent event, detail) {
    if (('enrollmentSelectedButton' == (Polymer.dom (event)).rootTarget.id) &&
        (null != selectedEnrollment)) {
      _previousContentDialog.close();

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

      set ('currentSection', null);
    }
  }
}
