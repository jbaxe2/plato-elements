@HtmlImport('enrollments_collection.html')
library plato_elements.enrollments_collection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show CourseEnrollment;
import 'simple_loader.dart';

@PolymerRegister('enrollments-collection')
class EnrollmentsCollection extends PolymerElement {
  @Property(notify: true)
  String username;

  @Property(notify: true)
  String password;

  @Property(notify: true)
  List<CourseEnrollment> enrollments;

  SimpleLoader _loader;

  /// The [EnrollmentsCollection] factory constructor.
  factory EnrollmentsCollection() => document.createElement ('enrollments-collection');

  /// The [EnrollmentsCollection] named constructor.
  EnrollmentsCollection.created() : super.created();

  /// The [attached] constructor...
  void attached() {
    enrollments = new List<CourseEnrollment>();

    _loader ??= $['enrollments-loader'] as SimpleLoader;
  }

  /// The [loadEnrollments] method...
  void loadEnrollments() {
    _loader.loadTypedData (data: {'username': username, 'password': password});
  }

  /// The [onEnrollmentsLoaded] method...
  @Listen('enrollments-loaded')
  void onEnrollmentsLoaded (CustomEvent event, details) {
    if (null != details['enrollments']) {
      try {
        enrollments = new List<CourseEnrollment>();

        details['enrollments'].forEach ((enrollDetails) {
          CourseEnrollment enrollment = new CourseEnrollment(
            enrollDetails['username'], enrollDetails['courseId'], enrollDetails['courseName'],
            enrollDetails['role'], enrollDetails['available']
          );

          async (() => add ('enrollments', enrollment));
        });

        notifyPath ('enrollments', enrollments);
      } catch (_) {}
    }
  }
}
