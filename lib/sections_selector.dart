@HtmlImport('sections_selector.html')
library plato.elements.selector.sections;

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
  @Listen('sections-loaded-complete')
  void updateHaveSections (CustomEvent event, details) => notifyPath (
    'haveSections', haveSections
  );

  /// The [onSectionsSelected] method...
  @Listen('tap')
  void onSectionsSelected (CustomEvent event, details) {
    if ((Polymer.dom (event)).rootTarget is PaperButton) {
      Map<String, BannerSection> selectedSections = new Map<String, BannerSection>();

      sections.forEach ((BannerSection section) {
        var sectionId = '${section.sectionId}_${section.termId}';
        var sectionCheckbox = $$('#${section.sectionId}-checkbox') as PaperCheckbox;

        if ((null != sectionCheckbox) && (sectionCheckbox.checked)) {
          selectedSections[sectionId] = section;
        }
      });

      if (0 < selectedSections.length) {
        this.fire ('iron-signal', detail: {
          'name': 'sections-added', 'data': {'sections': selectedSections}
        });
      }
    }
  }

  /// The [_haveSections] method...
  bool _haveSections() => ((null == sections) || (sections.isEmpty)) ? false : true;
}
