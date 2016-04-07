@HtmlImport('banner_department.html')
library plato_elements.banner_department;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

/// The [BannerDepartment] element class...
@PolymerRegister('banner-department')
class BannerDepartment extends PolymerElement {
  /// The 3 or 4 letter code for the department (such as ART or MATH).
  @Property(notify: true)
  String code;

  /// The description of the department.
  @Property(notify: true)
  String description;

  /// The [BannerDepartment] factory constructor.
  factory BannerDepartment() => document.createElement ('banner-department');

  /// The [BannerDepartment] constructor.
  BannerDepartment.created() : super.created();
}
