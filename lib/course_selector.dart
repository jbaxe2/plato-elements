@HtmlImport('course_selector.html')
library plato.elements.selector.course;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';

import 'data_models.dart' show BannerCourse;
import 'courses_collection.dart';

/// Silence analyzer:
/// [PaperDropdownMenu] - [PaperItem]
///
/// The [CourseSelector] element class...
@PolymerRegister('course-selector')
class CourseSelector extends PolymerElement {
  /// The [List] of [BannerCourse] instances.
  @Property(notify: true)
  List<BannerCourse> courses;

  @Property(notify: true)
  CoursesCollection _coursesCollection;

  /// The [CourseSelector] factory constructor.
  factory CourseSelector() => document.createElement ('course-selector');

  /// The [CourseSelector] constructor.
  CourseSelector.created() : super.created() {
    courses = new List<BannerCourse>();
  }

  /// The [attached] method...
  void attached() {
    _coursesCollection = new CoursesCollection();

    courses = _coursesCollection.courses;
  }

  /// The [onCourseSelected] method...
  @Listen('iron-select')
  void onCourseSelected (CustomEvent event, details) {
    var selectedCourse = ($['courses-menu'] as PaperMenu).selectedItem;
    var courseCode = null;

    courses.forEach ((BannerCourse course) {
      if (0 == course.courseTitle.trim().compareTo (selectedCourse.text.trim())) {
        courseCode = course.courseId;
      }
    });

    if (null != courseCode) {
      this.fire ('iron-signal', detail: {
        'name': 'course-selected', 'data': {'course': courseCode}
      });
    }
  }
}
