@HtmlImport('enrollments_collection.html')
library plato.elements.collection.enrollments;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show CourseEnrollment;
import 'plato_elements_utils.dart';
import 'simple_retriever.dart';

@PolymerRegister('enrollments-collection')
class EnrollmentsCollection extends PolymerElement {
  @Property(notify: true)
  String username;

  @Property(notify: true)
  List<CourseEnrollment> enrollments;

  SimpleRetriever _retriever;

  /// The [EnrollmentsCollection] factory constructor.
  factory EnrollmentsCollection() => document.createElement ('enrollments-collection');

  /// The [EnrollmentsCollection] named constructor.
  EnrollmentsCollection.created() : super.created();

  /// The [attached] constructor...
  void attached() {
    _retriever ??= $['enrollments-retriever'] as SimpleRetriever;
  }

  /// The [retrieveEnrollments] method...
  void retrieveEnrollments() {
    _retriever.retrieveTypedData();
  }

  /// The [onEnrollmentsRetrieved] method...
  @Listen('enrollments-retrieved')
  void onEnrollmentsRetrieved (CustomEvent event, details) {
    if (null != details['enrollments']) {
      try {
        set ('enrollments', new List<CourseEnrollment>());

        details['enrollments'].forEach ((enrollDetails) {
          if (enrollDetails['learn.user.username'] != username) {
            raiseError (this,
              'Enrollment retrieval error',
              'The retrieved enrollments do not match the authenticated user.'
            );
          }

          var enrollment = new CourseEnrollment (
            enrollDetails['learn.user.username'], enrollDetails['learn.course.id'],
            enrollDetails['learn.course.name'], enrollDetails['learn.membership.role'],
            enrollDetails['learn.membership.available']
          );

          async (() => add ('enrollments', enrollment));
        });

        this.fire ('iron-signal', detail: {
          'name': 'enrollments-retrieved-complete', 'data': {'enrollments': enrollments}
        });
      } catch (_) {}
    }
  }
}
