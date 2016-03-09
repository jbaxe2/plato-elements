@HtmlImport('requested_course.html')
library plato_elements.requested_course;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

//import 'banner_section.dart';

/// The [RequestedCourse] element class...
@PolymerRegister('requested-course')
class RequestedCourse extends PolymerElement {
  //BannerSection _bannerSection;

  @Property(observer: 'sectionIdChanged')
  String sectionId;

  /// The [RequestedCourse] factory constructor.
  factory RequestedCourse() => document.createElement ('requested-course');

  /// The [BannerDepartment] constructor.
  RequestedCourse.created() : super.created();

  @reflectable
  void sectionIdChanged (String newSectionId, String oldSectionId) {
    ;
  }
}
