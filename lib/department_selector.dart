@HtmlImport('department_selector.html')
library plato.elements.selector.department;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';

import 'data_models.dart' show BannerDepartment;
import 'departments_collection.dart';

/// Silence analyzer:
/// [PaperDropdownMenu] - [PaperItem]
///
/// The [DepartmentSelector] element class...
@PolymerRegister('department-selector')
class DepartmentSelector extends PolymerElement {
  /// The [List] of [BannerDepartment] instances.
  @Property(notify: true)
  List<BannerDepartment> departments;

  DepartmentsCollection _deptsCollection;

  /// The [DepartmentSelector] factory constructor.
  factory DepartmentSelector() => document.createElement ('department-selector');

  /// The [DepartmentSelector] constructor.
  DepartmentSelector.created() : super.created() {
    set ('departments', new List<BannerDepartment>());
  }

  /// The [attached] method...
  void attached() {
    _deptsCollection = new DepartmentsCollection();

    set ('departments', _deptsCollection.departments);
  }

  /// The [onDepartmentSelected] method...
  @Listen('iron-select')
  void onDepartmentSelected (CustomEvent event, details) {
    var selectedDept = ($['departments-menu'] as PaperMenu).selectedItem;
    var deptCode = null;

    departments.forEach ((BannerDepartment dept) {
      var deptDesc = '[${dept.code}] ${dept.description}'.trim();

      if (0 == deptDesc.compareTo (selectedDept.text.trim())) {
        deptCode = dept.code;
      }
    });

    if (null != deptCode) {
      this.fire ('iron-signal', detail: {
        'name': 'department-selected', 'data': {'department': deptCode}
      });
    }
  }
}
