@HtmlImport('section_view.html')
library plato.elements.view.section;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_icon_button.dart';

import 'data_models.dart' show BannerSection;

/// Silence analyzer:
/// [PaperCard] - [PaperIconButton]
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
    if ('copyContentIcon' == (Polymer.dom (event)).rootTarget.id) {
      window.console.log ('in on tab for copy content');
      window.console.debug ((Polymer.dom (event)).rootTarget.id);
    }
  }

  /// The [onAddToClSet] method...
  @Listen('tap')
  void onAddToClSet (CustomEvent event, details) {
    if ('addToClSetIcon' == (Polymer.dom (event)).rootTarget.id) {
      window.console.log ('in on tab for add to cl set');
      window.console.debug ((Polymer.dom (event)).rootTarget.id);
    }
  }

  /// The [onRemoveSection] method...
  @Listen('tap')
  void onRemoveSection (CustomEvent event, details) {
    if ('removeSectionIcon' == (Polymer.dom (event)).rootTarget.id) {
      window.console.debug ('in remove section, correctly');
    } else {
      window.console.debug ('in the wrong element for the on tap event');
      window.console.debug ((Polymer.dom (event)).rootTarget);
    }
  }
}
