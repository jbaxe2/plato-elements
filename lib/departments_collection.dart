@HtmlImport('departments_collection.html')
library plato.elements.collection.departments;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show BannerDepartment;
import 'simple_retriever.dart';

/// The [DepartmentsCollection] element class...
@PolymerRegister('departments-collection')
class DepartmentsCollection extends PolymerElement {
  /// The [List] of [BannerDepartment] instances.
  @Property(notify: true)
  List<BannerDepartment> departments;

  /// The [SimpleRetriever] element...
  SimpleRetriever _retriever;

  /// The [DepartmentsCollection] factory constructor.
  factory DepartmentsCollection() => document.createElement ('departments-collection');

  /// The [DepartmentsCollection] named constructor.
  DepartmentsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    departments = new List<BannerDepartment>();

    (_retriever ??= $['departments-retriever'] as SimpleRetriever)
      ..retrieveTypedData();
  }

  /// The [onDepartmentsRetrieved] method...
  @Listen('departments-retrieved')
  void onDepartmentsRetrieved (CustomEvent event, details) {
    if (null != details['departments']) {
      try {
        details['departments'].forEach ((deptDetails) {
          BannerDepartment department = new BannerDepartment (
            deptDetails['code'], deptDetails['description']
          );

          async (() {
            add ('departments', department);
          });
        });

        notifyPath ('departments', departments);
      } catch (_) {}
    }
  }
}
