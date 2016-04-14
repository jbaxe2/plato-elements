@HtmlImport('section_view_collection.html')
library plato_elements.section_view_collection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'data_models.dart' show BannerSection;
import 'section_view.dart';

/// Silence analyzer: [IronSignals] - [SectionView]
///
/// The [SectionViewCollection] class...
@PolymerRegister('section-view-collection')
class SectionViewCollection extends PolymerElement {
  @Property(notify: true)
  List<BannerSection> sections;

  @Property(notify: true)
  List<String> sectionIds;

  /// The [SectionViewCollection] factory constructor.
  factory SectionViewCollection() => document.createElement ('section-view-collection');

  /// The [SectionViewCollection] named constructor.
  SectionViewCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    sections = new List<BannerSection>();
    sectionIds = new List<String>();
  }

  /// The [onSectionsAdded] method...
  @Listen('iron-signal-sections-added')
  void onSectionsAdded (CustomEvent event, details) {
    if (null != details['sections']) {
      details['sections'].forEach ((String sectionId, BannerSection section) {
        if (!sections.contains (section)) {
          sections.add (section);
        }

        if (!sectionIds.contains (sectionId)) {
          sectionIds.add (sectionId);
        }
      });

      notifyPath ('sections', sections);
      notifyPath ('sectionIds', sectionIds);
    }
  }
}
