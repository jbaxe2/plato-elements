@HtmlImport('banner_department.html')
library plato_elements.banner_department;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

@PolymerRegister('banner-department')
class BannerDepartment extends PolymerElement {
  @property
  String departmentId;

  @property
  String description;

  /// The [BannerDepartment] factory constructor.
  factory BannerDepartment() => document.createElement ('banner-department');

  /// The [BannerDepartment] constructor.
  BannerDepartment.created() : super.created();
}
