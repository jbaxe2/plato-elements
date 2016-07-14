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
    print ('in on copy content');
    print (details);
  }

  /// The [onAddToClSet] method...
  @Listen('tap')
  void onAddToClSet (CustomEvent event, details) {
    print ('in on add to cross-listing set');
    print (details);
  }

  /// The [onRemoveSection] method...
  @Listen('tap')
  void onRemoveSection (CustomEvent event, details) {
    print ('in on remove section');
    print (details);
  }
}
