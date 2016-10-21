@HtmlImport('cross_listing_views_collection.html')
library plato.elements.collection.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_dialog.dart';

import 'data_models.dart' show BannerSection, CrossListing;

import 'section_view.dart';

/// Silence analyzer:
/// [PaperIconButton]
///
/// The [CrossListingViewsCollection] class...
@PolymerRegister('cross-listing-views-collection')
class CrossListingViewsCollection extends PolymerElement {
  @Property(notify: true)
  List<CrossListing> crossListings;

  @Property(notify: true)
  bool get haveCrossListings => _haveCrossListings;

  bool _haveCrossListings;

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

    notifyPath ('haveCrossListings', _haveCrossListings = false);

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

      notifyPath ('crossListings', crossListings.add (new CrossListing()));
      notifyPath ('haveCrossListings', _haveCrossListings = true);

      window.console.debug (crossListings);
    }
  }

  /// The [onCrossListingSelected] method...
  @Listen('tap')
  void onCrossListingSelected (CustomEvent event, details) {
    if ('crossListingSelectedButton' == (Polymer.dom (event)).localTarget.id) {
      ;
    }
  }
}
