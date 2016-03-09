@HtmlImport('banner_course.html')
library plato_elements.banner_course;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

/// The [BannerCourse] element class...
@PolymerRegister('banner-course')
class BannerCourse extends PolymerElement {
  @Property(notify: true)
  String courseId;

  @Property(notify: true)
  String courseTitle;

  /// The [BannerCourse] factory constructor.
  factory BannerCourse() => document.createElement ('banner-course');

  /// The [BannerCourse] constructor.
  BannerCourse.created() : super.created();
}
