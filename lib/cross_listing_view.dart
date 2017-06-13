@HtmlImport('cross_listing_view.html')
library plato.elements.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/av_icons.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_icon_button.dart';

import 'data_models.dart';

import 'plato_elements_utils.dart';

/// Silence analyzer:
/// [IronSignals] - [PaperCard] - [PaperIconButton]
///
/// The [CrossListingView] class establishes the view for interacting with one
/// particular cross-listing set.  Interactions with the cross-listing set are
/// performed under the context of a 'current' section.
@PolymerRegister('cross-listing-view')
class CrossListingView extends PolymerElement {
  /// The cross-listing serving as the main model for this element.
  @Property(notify: true)
  CrossListing crossListing;

  @Property(notify: true)
  int clSetNumber;

  @Property(computed: 'displayClSetNum(clSetNumber)')
  int clSetNumDisplay;

  /// True if the cross-listing contains one or more sections.
  @Property(notify: true)
  bool haveSections;

  /// The current section for which interactions with the cross-listing set shall
  /// provide context to.
  @Property(notify: true)
  BannerSection currentSection;

  /// True if the cross-listing contains the current section.
  @Property(notify: true)
  bool get clHasSection => _clHasSection;

  bool _clHasSection;

  /// The [CrossListingView] factory constructor.
  factory CrossListingView() => document.createElement ('cross-listing-view');

  /// The [CrossListingView] named constructor.
  CrossListingView.created() : super.created();

  /// The [attached] method...
  void attached() {
    if (null == crossListing) {
      set ('crossListing', new CrossListing());
    }

    set ('haveSections', !crossListing.sections.isEmpty);

    notifyPath (
      'clHasSection', _clHasSection = crossListing.sections.contains (currentSection)
    );
  }

  /// The [displayClSetNum] method...
  @reflectable
  int displayClSetNum (int clSetNumber) => clSetNumber + 1;

  /// The [onAddSectionToCl] method...
  @Listen('tap')
  void onAddSectionToCl (CustomEvent event, details) {
    if ('add-section-to-cl-icon' == (Polymer.dom (event)).localTarget.id) {
      if ((getRequestedSection (currentSection)).hasCrossListing) {
        raiseError (this,
          'Invalid cross-listing action warning',
          'Cannot add a section to a cross-listing set when that section is already '
            'a part of a different cross-listing set.'
        );

        return;
      }

      async (() {
        add ('crossListing.sections', currentSection);
        set ('haveSections', true);

        if (1 < crossListing.sections.length) {
          set ('crossListing.isValid', true);
        }

        refreshView();
      });
    }
  }

  /// The [onRemoveSectionFromCl] method...
  @Listen('tap')
  void onRemoveSectionFromCl (CustomEvent event, details) {
    if ('remove-section-from-cl-icon' == (Polymer.dom (event)).localTarget.id) {
      _removeSectionFromCl();

      notifyPath ('currentSection', currentSection);
    }
  }

  /// The [onRemoveCrossListingSet] method...
  @Listen('tap')
  void onRemoveCrossListingSet (CustomEvent event, details) {
    if ('remove-cl-set-icon' == (Polymer.dom (event)).localTarget.id) {
      _removeSectionFromCl();

      set ('crossListing.sections', new List<BannerSection>());

      this.fire ('remove-cross-listing-set', detail: {'crossListing': crossListing});

      refreshView();
    }
  }

  /// The [onSectionRemoved] method...
  @Listen('iron-signal-section-removed')
  void onSectionRemoved (CustomEvent event, details) => _sectionRemoved (event, details);

  /// The [onSectionRemovedFromCl] method...
  @Listen('iron-signal-section-removed-from-cl')
  void onSectionRemovedFromCl (CustomEvent event, details) => _sectionRemoved (event, details);

  /// The [_sectionRemoved] method...
  void _sectionRemoved (CustomEvent event, details) {
    if (null != details['section']) {
      _removeSectionFromCl (details['section'] as BannerSection);

      this.fire ('confirm-cl-sets-from-cl', detail: null);
    }
  }

  /// The [_removeSectionFromCl] method...
  void _removeSectionFromCl ([BannerSection section]) {
    section ??= currentSection;

    if (crossListing.sections.contains (section)) {
      removeItem ('crossListing.sections', section);

      if (crossListing.sections.isEmpty) {
        set ('haveSections', false);
      }

      if (2 > crossListing.sections.length) {
        set ('crossListing.isValid', false);
      }

      this.fire ('removed-section-from-cl', detail: {'crossListing': crossListing});
    }

    refreshView();
  }

  /// The [refreshView] method...
  void refreshView() {
    set ('haveSections', !crossListing.sections.isEmpty);

    notifyPath ('crossListing', crossListing);
    notifyPath ('currentSection', currentSection);

    if (haveSections) {
      notifyPath ('crossListing.sections', crossListing.sections);
      notifyPath (
        'clHasSection', _clHasSection = crossListing.sections.contains (currentSection)
      );
    } else {
      notifyPath ('clHasSection', _clHasSection = false);
    }
  }
}
