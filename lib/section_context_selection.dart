@HtmlImport('section_context_selection.html')
library plato_elements.section_context_selection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';

import 'departments_collection.dart';
import 'terms_collection.dart';
import 'courses_collection.dart';
import 'sections_collection.dart';

/// Silence analyzer:
/// [PaperDropdownMenu] - [PaperItem] - [PaperMenu]
@PolymerRegister('section-context-selection')
class SectionContextSelection extends PolymerElement {
  @Property(notify: true)
  DepartmentsCollection deptsColl;

  @Property(notify: true)
  TermsCollection termsColl;

  @Property(notify: true)
  CoursesCollection coursesColl;

  @Property(notify: true)
  SectionsCollection sectionsColl;

  /// The [SectionContextSelection] factory constructor...
  factory SectionContextSelection() => document.createElement ('section-context-selection');

  /// The [SectionContextSelection] named constructor...
  SectionContextSelection.created() : super.created();

  /// The [attached] method...
  void attached() {
    deptsColl ??= $['depts-collection'] as DepartmentsCollection;
    termsColl ??= $['terms-collection'] as TermsCollection;
  }

  @Listen('departments-loaded-completed')
  void refreshDeptsCollection (e, [_]) {
    notifyPath ('deptsColl', deptsColl.departments);

    window.console.debug (deptsColl.departments);
  }

  @Listen('terms-loaded-completed')
  void refreshTermsCollection (e, [_]) {
    notifyPath ('termsColl', termsColl);

    window.console.debug (termsColl.terms);
  }
}
