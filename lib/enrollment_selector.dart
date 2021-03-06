@HtmlImport('enrollment_selector.html')
library plato.elements.selector.enrollment;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_radio_button.dart';
import 'package:polymer_elements/paper_radio_group.dart';

import 'data_models.dart' show CourseEnrollment;

/// Silence analyzer:
/// [IronSignals]
/// [PaperRadioButton] - [PaperRadioGroup]
///
/// The [EnrollmentSelector] element class...
@PolymerRegister('enrollment-selector')
class EnrollmentSelector extends PolymerElement {
  /// The [List] of [CourseEnrollment] instances.
  @Property(notify: true)
  List<CourseEnrollment> enrollments;

  /// The [CourseEnrollment] instance representing the selected enrollment.
  @Property(notify: true)
  CourseEnrollment selectedEnrollment;

  @Property(notify: true)
  bool get enrollmentsRetrieved => _enrollmentsRetrieved;

  bool _enrollmentsRetrieved = false;

  /// The [EnrollmentSelector] factory constructor.
  factory EnrollmentSelector() => document.createElement ('enrollment-selector');

  /// The [EnrollmentSelector] constructor.
  EnrollmentSelector.created() : super.created() {
    set ('enrollments', new List<CourseEnrollment>());
  }

  /// The [attached] method...
  void attached();

  /// The [onEnrollmentsRetrievedComplete] method...
  @Listen('iron-signal-enrollments-retrieved-complete')
  void onEnrollmentsRetrievedComplete (CustomEvent event, details) {
    if (null != details['enrollments']) {
      async (() {
        addAll ('enrollments', details['enrollments']);
        notifyPath ('enrollmentsRetrieved', _enrollmentsRetrieved = true);

        this.fire ('enrollments-complete');
      });
    }
  }

  /// The [onArchivesRetrievedComplete] method...
  @Listen('iron-signal-archives-retrieved-complete')
  void onArchivesRetrievedComplete (CustomEvent event, details) {
    if (null != details['archives']) {
      async (() {
        addAll ('enrollments', details['archives']);
      });
    }
  }

  /// The [onBrowseArchive] method...
  @Listen('tap')
  void onBrowseArchive (CustomEvent event, details) {
    var archiveLink = (Polymer.dom (event)).localTarget.id as String;

    if (archiveLink.contains ('-archive-link')) {
      this.fire ('iron-signal', detail: {
        'name': 'browse-archive',
        'data': {
          'archiveId': archiveLink.split ('-').first
        }
      });
    }
  }

  /// The [onEnrollmentSelected] method...
  @Listen('iron-select')
  void onEnrollmentSelected (CustomEvent event, details) {
    set (
      'selectedEnrollment',
      ($['enrollmentSelector'] as PaperRadioGroup).selectedItem.value
    );
  }

  /// The [onEnrollmentDeselected] method...
  @Listen('iron-deselect')
  void onEnrollmentDeselected (CustomEvent event, details) =>
    set ('selectedEnrollment', null);
}
