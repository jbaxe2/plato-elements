@HtmlImport('banner_course.html')
library plato_elements.banner_course;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

@PolymerRegister('banner-course')
class BannerCourse extends PolymerElement {
  @property
  String courseId;

  @property
  String courseTitle;

  /// The [BannerCourse] factory constructor.
  factory BannerCourse() => document.createElement ('banner-course');

  /// The [BannerCourse] constructor.
  BannerCourse.created() : super.created();
}
