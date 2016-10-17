@HtmlImport('section_view.html')
library plato.elements.view.section;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_material.dart';

import 'data_models.dart' show BannerSection;

/// Silence analyzer:
/// [PaperCard] - [PaperIconButton] - [PaperMaterial]
///
/// The [SectionView] class...
@PolymerRegister('section-view')
class SectionView extends PolymerElement {
  @Property(notify: true)
  BannerSection section;

  /// The [SectionView] factory constructor.
  factory SectionView() => document.createElement ('section-view');

  /// The [SectionView] named constructor.
  SectionView.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [updateSection] method...
  void updateSection (BannerSection newSection) => set ('section', newSection);

  /// The [onCopyContent] method...
  @Listen('tap')
  void onCopyContent (CustomEvent event, details) {
    if ('copyContentIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'show-copy-content-selector', 'data': {'section': section}
      });
    }
  }

  /// The [onAddToClSet] method...
  @Listen('tap')
  void onAddToClSet (CustomEvent event, details) {
    if ('addToClSetIcon' == (Polymer.dom (event)).localTarget.id) {
      window.console.debug (section);
      window.console.debug (
        'add to cl set for ${(Polymer.dom (event)).localTarget.parent.parent.attributes['heading']}'
      );
    }
  }

  /// The [onRemoveSection] method...
  @Listen('tap')
  void onRemoveSection (CustomEvent event, details) {
    if ('removeSectionIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'section-removed', 'data': {'section': section}
      });
    }
  }
}
