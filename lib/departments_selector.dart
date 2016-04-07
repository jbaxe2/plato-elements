@HtmlImport('departments_selector.html')
library plato_elements.departments_selector;

import 'dart:async';
import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';

import 'banner_department.dart';
import 'departments_collection.dart';

/// Silence analyzer:
/// [PaperDropdownMenu] - [PaperItem] - [PaperMenu]
///
/// The [DepartmentsSelector] element class...
@PolymerRegister('departments-selector')
class DepartmentsSelector extends PolymerElement {
  /// The [List] of [BannerDepartment] instances.
  @Property(notify: true)
  List<BannerDepartment> departments;

  @Property(notify: true)
  DepartmentsCollection _deptsCollection;

  /// The [DepartmentsSelector] factory constructor.
  factory DepartmentsSelector() => document.createElement ('departments-selector');

  /// The [DepartmentsSelector] constructor.
  DepartmentsSelector.created() : super.created() {
    departments = new List<BannerDepartment>();
  }

  /// The [attached] method...
  void attached() {
    _deptsCollection = new DepartmentsCollection();

    departments = _deptsCollection.departments;
  }
}
