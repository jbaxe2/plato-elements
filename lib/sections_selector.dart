@HtmlImport('sections_selector.html')
library plato_elements.sections_selector;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_checkbox.dart';

import 'data_models.dart' show BannerSection;
import 'sections_collection.dart';

/// Silence analyzer:
/// [IronSignals]
/// [PaperButton] - [PaperCard] - [PaperCheckbox]
///
/// The [SectionsSelector] element class...
@PolymerRegister('sections-selector')
class SectionsSelector extends PolymerElement {
  /// The [List] of [BannerSection] instances.
  @Property(notify: true)
  List<BannerSection> sections;

  @Property(notify: true)
  SectionsCollection _sectionsCollection;

  @Property(notify: true)
  String termId;

  @Property(notify: true)
  bool get haveSections => _haveSections();

  /// The [SectionsSelector] factory constructor.
  factory SectionsSelector() => document.createElement ('sections-selector');

  /// The [SectionsSelector] constructor.
  SectionsSelector.created() : super.created() {
    sections = new List<BannerSection>();
  }

  /// The [attached] method...
  void attached() {
    _sectionsCollection = new SectionsCollection();

    sections = _sectionsCollection.sections;
    termId = _sectionsCollection.termId;
  }

  /// The [updateHaveSections] method...
  @Listen('sections-finished-loading')
  void updateHaveSections (CustomEvent event, details) => notifyPath (
    'haveSections', haveSections
  );

  /// The [onSectionsSelected] method...
  @Listen('tap')
  void onSectionsSelected (CustomEvent event, details) {
    window.console.log ('there may be some sections selected');
  }

  /// The [_haveSections] method...
  bool _haveSections() => ((null == sections) || (sections.isEmpty)) ? false : true;
}
