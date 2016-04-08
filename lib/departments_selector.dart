@HtmlImport('departments_selector.html')
library plato_elements.departments_selector;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';

import 'data_models.dart' show BannerDepartment;
import 'departments_collection.dart';

/// Silence analyzer:
/// [PaperDropdownMenu] - [PaperItem] - [IronSignals]
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

  /// The [onDepartmentSelected] method...
  @Listen('iron-select')
  void onDepartmentSelected (CustomEvent event, details) {
    var selectedDept = ($['department-menu'] as PaperMenu).selectedItem;
    var deptCode = null;

    departments.forEach ((BannerDepartment dept) {
      if (0 == dept.description.trim().compareTo (selectedDept.text.trim())) {
        deptCode = dept.code;
      }
    });

    if (null != deptCode) {
      window.console.log ('Got here to fire dept code signal with $deptCode');

      this.fire ('iron-signal', detail: {
        'name': 'department-selected',
        'data': {'department': deptCode}
      });
    }
  }
}
