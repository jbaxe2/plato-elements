@HtmlImport('departments_collection.html')
library plato_elements.departments_collection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'banner_department.dart';
import 'simple_loader.dart';

/// The [DepartmentsCollection] element class...
@PolymerRegister('departments-collection')
class DepartmentsCollection extends PolymerElement {
  /// The [List] of [BannerDepartment] instances.
  @Property(notify: true)
  List<BannerDepartment> departments;

  /// The [SimpleLoader] element...
  SimpleLoader _loader;

  /// The [DepartmentsCollection] factory constructor.
  factory DepartmentsCollection() => document.createElement ('departments-collection');

  /// The [DepartmentsCollection] named constructor.
  DepartmentsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    departments = new List<BannerDepartment>();

    (_loader ??= $['departments-loader'] as SimpleLoader)
      ..loadTypedData (isPost: false);
  }

  /// The [handleDeptsLoaded] method...
  @Listen('departments-loaded')
  void handleDeptsLoaded (CustomEvent event, details) {
    if (null != details['departments']) {
      try {
        details['departments'].forEach ((deptDetails) {
          BannerDepartment department = new BannerDepartment()
            ..code = deptDetails['code']
            ..description = deptDetails['description'];

          async (() {
            add ('departments', department);
          });
        });

        notifyPath ('departments', departments);
      } catch (e) {
        window.console.debug (e);
      }

      //this.fire ('departments-loaded-completed');
    }
  }
}
