@HtmlImport('banner_course.html')
library plato_elements.lib.banner_course;

import 'dart:html' show document;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('banner-course')
class BannerCourse extends PolymerElement {
  @property
  String courseId;

  @property
  String courseTitle;

  /// The [BannerCourse] constructor.
  BannerCourse.created() : super.created();

  /// The [BannerCourse] factory constructor.
  factory BannerCourse() => document.createElement ('banner-course');
}
