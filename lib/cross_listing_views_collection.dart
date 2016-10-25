@HtmlImport('cross_listing_views_collection.html')
library plato.elements.collection.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_dialog.dart';

import 'data_models.dart' show BannerSection, CrossListing;

import 'cross_listing_view.dart';
import 'section_view.dart';

/// Silence analyzer:
/// [PaperIconButton] - [CrossListingView]
///
/// The [CrossListingViewsCollection] class...
@PolymerRegister('cross-listing-views-collection')
class CrossListingViewsCollection extends PolymerElement {
  @Property(notify: true)
  List<CrossListing> crossListings;

  @Property(notify: true)
  SectionView get currentSectionView => _currentSectionView;

  SectionView _currentSectionView;

  @Property(notify: true)
  BannerSection get currentSection => _currentSection;

  BannerSection _currentSection;

  PaperDialog _clDialog;

  /// The [CrossListingViewsCollection] factory constructor...
  factory CrossListingViewsCollection() => document.createElement ('cross-listing-views-collection');

  /// The [CrossListingViewsCollection] named constructor...
  CrossListingViewsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    crossListings = new List<CrossListing>();

    _clDialog = $['cross-listing-dialog'] as PaperDialog;
  }

  /// The [onShowCrossListingSelector] method...
  @Listen('iron-signal-show-cross-listing-selector')
  void onShowCrossListingSelector (CustomEvent event, details) {
    if (null != details['sectionView']) {
      notifyPath (
        'currentSectionView', _currentSectionView = details['sectionView'] as SectionView
      );

      notifyPath ('currentSection', _currentSection = _currentSectionView.section);

      _clDialog
        ..refit()
        ..center()
        ..open();
    }
  }

  /// The [addNewClSet] method...
  @Listen('tap')
  void addNewClSet (CustomEvent event, details) {
    if ('addNewClSetIcon' == (Polymer.dom (event)).localTarget.id) {
      if (crossListings.any (
        (CrossListing crossListing) => (crossListing.sections.isEmpty) ? true : false
      )) {
        return;
      }

      crossListings.add (new CrossListing());

      notifyPath ('crossListings', crossListings);

      _clDialog
        ..refit()
        ..center();
    }
  }

  /// The [onRemoveCrossListingSet] method...
  @Listen('remove-cross-listing-set')
  void onRemoveCrossListingSet (CustomEvent event, details) {
    window.console.debug (details);

    if (null != details['crossListing']) {
      try {
        crossListings.remove (details['crossListing'] as CrossListing);
      } catch (_) {}

      notifyPath ('crossListings', crossListings);

      _clDialog
        ..refit()
        ..center();
    }
  }

  /// The [onCrossListingConfirmed] method...
  @Listen('tap')
  void onCrossListingConfirmed (CustomEvent event, details) {
    if ('crossListingConfirmedButton' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('cross-listing-confirmed', detail: {'section': currentSection});
    }
  }
}
