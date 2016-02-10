@HtmlImport('requested_course.html')
library plato_elements.lib.requested_course;

import 'dart:html' show document;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

//import 'banner_section.dart';

@PolymerRegister('requested-course')
class RequestedCourse extends PolymerElement {
  //BannerSection _bannerSection;

  @Property(observer: 'sectionIdChanged')
  String sectionId;

  /// The [BannerDepartment] constructor.
  RequestedCourse.created() : super.created();

  /// The [RequestedCourse] factory constructor.
  factory RequestedCourse() => document.createElement ('requested-course');

  @reflectable
  void sectionIdChanged (String newSectionId, String oldSectionId) {
    ;
  }
}
