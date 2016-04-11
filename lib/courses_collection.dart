@HtmlImport('courses_collection.html')
library plato_elements.courses_collection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'data_models.dart' show BannerCourse;
import 'simple_loader.dart';

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

  /// The [SimpleLoader] element...
  SimpleLoader _loader;

  /// The [CoursesCollection] factory constructor.
  factory CoursesCollection() => document.createElement ('courses-collection');

  /// The [CoursesCollection] constructor.
  CoursesCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    courses = new List<BannerCourse>();

    _loader ??= $['courses-loader'] as SimpleLoader;
  }

  /// The [updateDeptAndTerm] method...
  @Observe('departmentId, termId')
  void updateDeptAndTerm (String newDeptId, String newTermId) {
    _loader.loadTypedData (
      isPost: false, data: {'dept': departmentId, 'term': termId}
    );
  }

  /// The [handleDepartmentSelected] method...
  @Listen('iron-signal-department-selected')
  void handleDepartmentSelected (CustomEvent event, details) {
    if (null != details['department']) {
      departmentId = details['department'];

      notifyPath ('departmentId', departmentId);
    }
  }

  /// The [handleTermSelected] method...
  @Listen('iron-signal-term-selected')
  void handleTermSelected (CustomEvent event, details) {
    if (null != details['term']) {
      termId = details['term'];

      notifyPath ('termId', termId);
    }
  }

  /// The [handleCoursesLoaded] method...
  @Listen('courses-loaded')
  void handleCoursesLoaded (CustomEvent event, details) {
    if (null != details['courses']) {
      try {
        details['courses'].forEach ((courseDetails) {
          BannerCourse course = new BannerCourse (
            courseDetails['crsno'], courseDetails['title']
          );

          async (() {
            add ('courses', course);
          });
        });

        notifyPath ('courses', courses);
      } catch (_) {}
    }
  }
}
