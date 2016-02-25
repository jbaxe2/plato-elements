@HtmlImport('departments_collection.html')
library plato_elements.departments_collection;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'banner_department.dart';
import 'simple_loader.dart';

@PolymerRegister('departments-collection')
class DepartmentsCollection extends PolymerElement {
  /// The [List] of [BannerDepartment] instances.
  @Property(notify: true)
  List<BannerDepartment> departments;

  /// The [SimpleLoader] element...
  SimpleLoader _loader;

  /// The [DepartmentsCollection] factory constructor.
  factory DepartmentsCollection() => document.createElement ('departments-collection');

  /// The [DepartmentsCollection] constructor.
  DepartmentsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    (_loader ??= $['departments-loader'] as SimpleLoader)
      ..loadTypedData();
  }

  /// The [handleDeptsLoaded] method...
  @Listen('departments-loaded')
  void handleDeptsLoaded (event, details) {
    ;
  }
}
