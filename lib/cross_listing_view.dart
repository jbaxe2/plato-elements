@HtmlImport('cross_listing_view.html')
library plato.elements.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/av_icons.dart';

import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_icon_button.dart';

import 'data_models.dart' show BannerSection, CrossListing;

/// Silence analyzer:
/// [PaperCard] - [PaperIconButton]
///
/// The [CrossListingView] class...
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
    notifyPath ('haveSections', haveSections = false);

    notifyPath (
      'clHasSection', _clHasSection = crossListing.sections.contains (currentSection)
    );

    if (null == crossListing) {
      crossListing = new CrossListing();
    }
  }

  /// The [displayClSetNum] method...
  @reflectable
  int displayClSetNum (int clSetNumber) => clSetNumber + 1;

  /// The [onAddSectionToCl] method...
  @Listen('tap')
  void onAddSectionToCl (CustomEvent event, details) {
    if (('addSectionToClIcon' == (Polymer.dom (event)).localTarget.id) &&
        (!currentSection.hasCrossListing)) {
      crossListing.addSection (currentSection);

      currentSection.hasCrossListing = true;

      notifyPath ('crossListing', crossListing);
      notifyPath ('haveSections', haveSections = true);
      notifyPath ('clHasSection', _clHasSection = true);
      notifyPath ('currentSection', currentSection);
    }
  }

  /// The [onRemoveSectionFromCl] method...
  @Listen('tap')
  void onRemoveSectionFromCl (CustomEvent event, details) {
    if ('removeSectionFromClIcon' == (Polymer.dom (event)).localTarget.id) {
      _removeSectionFromCl();
    }
  }

  /// The [onRemoveCrossListingSet] method...
  @Listen('tap')
  void onRemoveCrossListingSet (CustomEvent event, details) {
    if ('removeClSetIcon' == (Polymer.dom (event)).localTarget.id) {
      _removeSectionFromCl();
      crossListing.sections.clear();

      notifyPath ('crossListing', crossListing);
      notifyPath ('currentSection', currentSection);

      this.fire ('remove-cross-listing-set', detail: {'crossListing': crossListing});
    }
  }

  /// The [_removeSectionFromCl] method...
  void _removeSectionFromCl() {
    if (crossListing.sections.contains (currentSection)) {
      crossListing.removeSection (currentSection);

      currentSection.hasCrossListing = false;

      notifyPath ('crossListing', crossListing);
      notifyPath ('clHasSection', _clHasSection = false);
      notifyPath ('currentSection', currentSection);

      if (crossListing.sections.isEmpty) {
        notifyPath ('haveSections', haveSections = false);
      }
    }
  }
}
