@HtmlImport('section_views_collection.html')
library plato.elements.collection.view.section;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_card.dart';

import 'data_models.dart' show BannerSection, RequestedSection, getRequestedSection;
import 'plato_elements_utils.dart';
import 'section_view.dart';

/// Silence analyzer:
/// [IronSignals] - [PaperCard]
/// [SectionView] - [RequestedSection]
///
/// The [SectionViewsCollection] class establishes the potential collection of
/// one or more section views.  This collection of section views MUST be singleton,
/// although there are no protections to prevent more than one instance from being
/// created.  One or more sections may be added to this collection at a time,
/// while only one section may be removed at a time.  Sections that are a part
/// of this collection represent those that should be part of the course request.
@PolymerRegister('section-views-collection')
class SectionViewsCollection extends PolymerElement {
  @Property(notify: true)
  List<BannerSection> sections;

  @Property(notify: true)
  List<String> sectionIds;

  @Property(notify: true)
  bool haveSections;

  /// The [SectionViewsCollection] factory constructor.
  factory SectionViewsCollection() => document.createElement ('section-views-collection');

  /// The [SectionViewsCollection] named constructor.
  SectionViewsCollection.created() : super.created();

  /// The [attached] method provides some initialization for when the section
  /// views collection element has been added to the DOM.
  void attached() {
    set ('sections', new List<BannerSection>());
    set ('sectionIds', new List<String>());
    set ('haveSections', false);
  }

  /// The [onSectionsAdded] method allows for the addition of one or more sections
  /// to the collection, whereby a section view will be created for each section.
  /// This method will prevent the addition of the same section multiple times.
  @Listen('iron-signal-sections-added')
  void onSectionsAdded (CustomEvent event, details) {
    if (null != details['sections']) {
      async (() {
        details['sections'].forEach ((String sectionId, BannerSection section) {
          if (!(sectionIds.contains (sectionId) && sections.contains (section))) {
            add ('sectionIds', sectionId);
            add ('sections', section);
          }
        });
      });

      set ('haveSections', true);

      this.fire ('iron-signal', detail: {
        'name': 'course-request-submittable', 'data': {'crfSubmittable': true}
      });
    }
  }

  /// The [onSectionRemoved] method establishes that one (and only one) section
  /// may be removed from the collection, for which the arguments passed will
  /// specify which section is to be removed.
  @Listen('iron-signal-section-removed')
  void onSectionRemoved (CustomEvent event, details) {
    if (null != details['section']) {
      var section = details['section'] as BannerSection;
      var sectionId = '${section.sectionId}_${section.termId}';

      if (!(sections.contains (section) && (sectionIds.contains (sectionId)))) {
        raiseError (this,
          'Invalid action warning',
          'Cannot remove a non-requested section from the request.'
        );

        return;
      }

      getRequestedSection (section)
        ..removeCrossListing()
        ..removePreviousContent();

      removeItem ('sections', section);
      removeItem ('sectionIds', sectionId);

      if (sections.isEmpty) {
        set ('haveSections', false);

        this.fire ('iron-signal', detail: {
          'name': 'course-request-submittable', 'data': {'crfSubmittable': false}
        });
      }
    }
  }

  /// The [onCollectInfoCrfReview] method...
  @Listen('iron-signal-collect-info-crf-review')
  void onCollectInfoCrfReview (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {
      'name': 'collect-sections-info', 'data': {'sections': sections}
    });
  }
}
