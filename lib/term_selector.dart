@HtmlImport('term_selector.html')
library plato_elements.term_selector;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';

import 'data_models.dart' show LearnTerm;
import 'terms_collection.dart';

/// Silence analyzer:
/// [PaperDropdownMenu] - [PaperItem] - [PaperMenu]
///
/// The [TermSelector] element class...
@PolymerRegister('term-selector')
class TermSelector extends PolymerElement {
  /// The [List] of [LearnTerm] instances.
  @Property(notify: true)
  List<LearnTerm> terms;

  @Property(notify: true)
  TermsCollection _termsCollection;

  /// The [TermSelector] factory constructor.
  factory TermSelector() => document.createElement ('term-selector');

  /// The [TermSelector] constructor.
  TermSelector.created() : super.created() {
    terms = new List<LearnTerm>();
  }

  /// The [attached] method...
  void attached() {
    _termsCollection = new TermsCollection();

    terms = _termsCollection.terms;
  }

  /// The [onTermSelected] method...
  @Listen('iron-select')
  void onTermSelected (CustomEvent event, details) {
    var selectedTerm = ($['terms-menu'] as PaperMenu).selectedItem;
    var termCode = null;

    terms.forEach ((LearnTerm term) {
      if (0 == term.description.trim().compareTo (selectedTerm.text.trim())) {
        termCode = term.termId;
      }
    });

    if (null != termCode) {
      this.fire ('iron-signal', detail: {
        'name': 'term-selected', 'data': {'term': termCode}
      });
    }
  }
}
