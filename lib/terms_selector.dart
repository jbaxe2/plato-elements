@HtmlImport('terms_selector.html')
library plato_elements.terms_selector;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';

import 'data_models.dart' show BannerTerm;
import 'terms_collection.dart';

/// Silence analyzer:
/// [PaperDropdownMenu] - [PaperItem] - [PaperMenu]
///
/// The [TermsSelector] element class...
@PolymerRegister('terms-selector')
class TermsSelector extends PolymerElement {
  /// The [List] of [BannerTerm] instances.
  @Property(notify: true)
  List<BannerTerm> terms;

  @Property(notify: true)
  TermsCollection _termsCollection;

  /// The [TermsSelector] factory constructor.
  factory TermsSelector() => document.createElement ('terms-selector');

  /// The [TermsSelector] constructor.
  TermsSelector.created() : super.created() {
    terms = new List<BannerTerm>();
  }

  /// The [attached] method...
  void attached() {
    _termsCollection = new TermsCollection();

    terms = _termsCollection.terms;
  }
}
