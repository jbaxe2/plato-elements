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
      _currentSectionView = details['sectionView'] as SectionView;
      _currentSection = _currentSectionView.section;

      notifyPath ('currentSectionView', _currentSectionView);
      notifyPath ('currentSection', _currentSection);

      if (!crossListings.isEmpty) {
        notifyPath ('crossListings', crossListings);
      }

      var clViewsList = this.querySelectorAll ('cross-listing-view');

      clViewsList.forEach (
        (Element viewElement) => (viewElement as CrossListingView).updateView()
      );

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

      async (() {
        add ('crossListings', new CrossListing());
      });

      notifyPath ('crossListings', crossListings);

      _clDialog
        ..refit()
        ..center();
    }
  }

  /// The [onRemoveCrossListingSet] method...
  @Listen('remove-cross-listing-set')
  void onRemoveCrossListingSet (CustomEvent event, details) {
    if (null != details['crossListing']) {
      var crossListing = details['crossListing'] as CrossListing;

      removeItem ('crossListings', crossListing);
      crossListings.remove (crossListing);

      notifyPath ('crossListings', crossListings);

      _clDialog
        ..refit()
        ..center();
    }
  }
}
