@HtmlImport('enrollment_selector.html')
library plato.elements.selector.enrollment;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_radio_group.dart';
import 'package:polymer_elements/paper_radio_button.dart';

import 'data_models.dart' show CourseEnrollment;

/// The [EnrollmentSelector] element class...
@PolymerRegister('enrollment-selector')
class EnrollmentSelector extends PolymerElement {
  /// The [List] of [CourseEnrollment] instances.
  @Property(notify: true)
  List<CourseEnrollment> enrollments;

  /// The [EnrollmentSelector] factory constructor.
  factory EnrollmentSelector() => document.createElement ('enrollment-selector');

  /// The [EnrollmentSelector] constructor.
  EnrollmentSelector.created() : super.created() {
    enrollments = new List<CourseEnrollment>();
  }

  /// The [attached] method...
  void attached() {}

  /// The [onEnrollmentsRetrievedComplete] method...
  @Listen('iron-signal-enrollments-retrieved-complete')
  void onEnrollmentsRetrievedComplete (CustomEvent event, details) {
    ;
  }

  /// The [onEnrollmentSelected] method...
  @Listen('iron-select')
  void onEnrollmentSelected (CustomEvent event, details) {}
}
