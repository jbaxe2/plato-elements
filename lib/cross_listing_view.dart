@HtmlImport('cross_listing_view.html')
library plato.elements.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/av_icons.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_icon_button.dart';

import 'data_models.dart' show BannerSection, CrossListing, RequestedSection;

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

  /// The current section for which interactions with the cross-listing shall be used.
  @Property(notify: true)
  BannerSection currentSection;

  RequestedSection _requestedSection;

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

    _requestedSection = new RequestedSection (currentSection);
  }

  /// The [displayClSetNum] method...
  @reflectable
  int displayClSetNum (int clSetNumber) => clSetNumber + 1;

  /// The [onAddSectionToCl] method...
  @Listen('tap')
  void onAddSectionToCl (CustomEvent event, details) {
    if (('addSectionToClIcon' == (Polymer.dom (event)).localTarget.id) &&
        (crossListing.isCrossListableWith (currentSection))) {
      if (!_requestedSection.canUseCrossListing (crossListing)) {
        raiseError (this,
          'Invalid cross-listing action warning',
          'Unable to cross-list this section, as its previous content differs from the previous content of the other section(s).'
        );

        return;
      }

      async (() {
        add ('crossListing.sections', currentSection);

        set ('currentSection.hasCrossListing', true);
        set ('haveSections', true);

        if (1 < crossListing.sections.length) {
          set ('crossListing.isValid', true);
        }

        notifyPath ('crossListing', crossListing);
        notifyPath ('currentSection', currentSection);
        notifyPath (
          'clHasSection', _clHasSection = crossListing.sections.contains (currentSection)
        );
      });
    }
  }

  /// The [onRemoveSectionFromCl] method...
  @Listen('tap')
  void onRemoveSectionFromCl (CustomEvent event, details) {
    if ('removeSectionFromClIcon' == (Polymer.dom (event)).localTarget.id) {
      _removeSectionFromCl (currentSection);

      notifyPath ('currentSection', currentSection);
    }
  }

  /// The [onRemoveCrossListingSet] method...
  @Listen('tap')
  void onRemoveCrossListingSet (CustomEvent event, details) {
    if ('removeClSetIcon' == (Polymer.dom (event)).localTarget.id) {
      _removeSectionFromCl (currentSection);
      crossListing.sections.clear();

      notifyPath ('crossListing', crossListing);
      notifyPath ('currentSection', currentSection);

      this.fire ('remove-cross-listing-set', detail: {'crossListing': crossListing});
    }
  }

  /// The [onSectionRemovedFromCl] method...
  @Listen('iron-signal-section-removed-from-cl')
  void onSectionRemovedFromCl (CustomEvent event, details) {
    if (null != details['section']) {
      _removeSectionFromCl (currentSection);

      if (null != details['crossListing']) {
        var _crossListing = details['crossListing'] as CrossListing;

        if (_crossListing.sections.contains (currentSection)) {
          _crossListing.removeSection (currentSection);
        }
      }

      this.fire ('confirm-cl-sets-from-cl', detail: null);
    }
  }

  /// The [_removeSectionFromCl] method...
  void _removeSectionFromCl (BannerSection theSection) {
    if (crossListing.sections.contains (theSection)) {
      removeItem ('crossListing.sections', theSection);
      notifyPath ('crossListing', crossListing);

      if (crossListing.sections.isEmpty) {
        set ('haveSections', false);
      }

      if (2 > crossListing.sections.length) {
        set ('crossListing.isValid', false);
      }
    }

    if (theSection == currentSection) {
      notifyPath ('clHasSection', _clHasSection = false);
    }

    this.fire ('removed-section-from-cl', detail: {'crossListing': crossListing});
  }

  /// The [updateView] method...
  void updateView() {
    notifyPath ('crossListing', crossListing);
    notifyPath ('haveSections', haveSections);
    notifyPath ('currentSection', currentSection);
    notifyPath (
      'clHasSection', _clHasSection = crossListing.sections.contains (currentSection)
    );
  }
}
