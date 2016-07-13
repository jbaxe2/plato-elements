@HtmlImport('course_request.html')
library plato.elements.request.course;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

@PolymerRegister('course-request')
class CourseRequest extends PolymerElement {
  @property
  String request;

  /// Constructor used to create instance of CourseRequest.
  CourseRequest.created() : super.created();

  // Optional lifecycle methods - uncomment if needed.
//  /// Called when an instance of main-app is inserted into the DOM.
//  attached() {
//    super.attached();
//  }

//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanged(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).
//  ready() {
//  }
}
