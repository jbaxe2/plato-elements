@HtmlImport('section_views_collection.html')
library plato.elements.collection.view.section;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'data_models.dart' show BannerSection;
import 'section_view.dart';

/// Silence analyzer: [IronSignals] - [SectionView]
///
/// The [SectionViewsCollection] class...
@PolymerRegister('section-views-collection')
class SectionViewsCollection extends PolymerElement {
  @Property(notify: true)
  List<BannerSection> sections;

  @Property(notify: true)
  List<String> sectionIds;

  /// The [SectionViewsCollection] factory constructor.
  factory SectionViewsCollection() => document.createElement ('section-views-collection');

  /// The [SectionViewsCollection] named constructor.
  SectionViewsCollection.created() : super.created();

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
