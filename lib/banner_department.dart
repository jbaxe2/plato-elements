@HtmlImport('banner_department.html')
library plato_elements.lib.banner_department;

import 'dart:html' show document;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('banner-department')
class BannerDepartment extends PolymerElement {
  @property
  String departmentId;

  @property
  String description;

  /// The [BannerDepartment] constructor.
  BannerDepartment.created() : super.created();

  /// The [BannerDepartment] factory constructor.
  factory BannerDepartment() => document.createElement ('banner-department');
}
