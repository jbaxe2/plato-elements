@HtmlImport('courses_collection.html')
library plato.elements.collection.courses;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'data_models.dart' show BannerCourse;
import 'simple_retriever.dart';

/// Silence analyzer [IronSignals]
///
/// The [CoursesCollection] element class...
@PolymerRegister('courses-collection')
class CoursesCollection extends PolymerElement {
  /// The ID of the department associated with the courses.
  @Property(notify: true)
  String departmentId;

  /// The ID of the term associated with the courses.
  @Property(notify: true)
  String termId;

  /// The [List] of [BannerCourse] instances.
  @Property(notify: true)
  List<BannerCourse> courses;

  /// The [SimpleRetriever] element...
  SimpleRetriever _retriever;

  /// The [CoursesCollection] factory constructor.
  factory CoursesCollection() => document.createElement ('courses-collection');

  /// The [CoursesCollection] constructor.
  CoursesCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    courses = new List<BannerCourse>();

    _retriever ??= $['courses-retriever'] as SimpleRetriever;
  }

  /// The [updateDeptAndTerm] method...
  @Observe('departmentId, termId')
  void updateDeptAndTerm (String newDeptId, String newTermId) {
    _retriever.retrieveTypedData (
      data: {'dept': departmentId, 'term': termId}
    );
  }

  /// The [onDepartmentSelected] method...
  @Listen('iron-signal-department-selected')
  void onDepartmentSelected (CustomEvent event, details) {
    if (null != details['department']) {
      departmentId = details['department'];

      notifyPath ('departmentId', departmentId);
    }
  }

  /// The [onTermSelected] method...
  @Listen('iron-signal-term-selected')
  void onTermSelected (CustomEvent event, details) {
    if (null != details['term']) {
      termId = details['term'];

      notifyPath ('termId', termId);
    }
  }

  /// The [onCoursesLoaded] method...
  @Listen('courses-retrieved')
  void onCoursesRetrieved (CustomEvent event, details) {
    if (null != details['courses']) {
      try {
        courses = new List<BannerCourse>();

        details['courses'].forEach ((courseDetails) {
          var course = new BannerCourse (
            courseDetails['courseId'], courseDetails['title']
          );

          async (() => add ('courses', course));
        });

        notifyPath ('courses', courses);
      } catch (_) {}
    }
  }
}
