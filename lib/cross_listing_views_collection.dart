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
    set ('crossListings', new List<CrossListing>());

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

      var clViewsList = this.querySelectorAll ('cross-listing-view');

      clViewsList.forEach (
        (Element viewElement) => (viewElement as CrossListingView).updateView()
      );

      updateView();

      _clDialog.open();
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

      updateView();
    }
  }

  /// The [onRemoveCrossListingSet] method...
  @Listen('remove-cross-listing-set')
  void onRemoveCrossListingSet (CustomEvent event, details) {
    if (null != details['crossListing']) {
      var crossListing = details['crossListing'] as CrossListing;

      removeItem ('crossListings', crossListing);

      _removalCleanup (crossListing);
    }
  }

  /// The [onRemovedSectionFromCl] method...
  @Listen('removed-section-from-cl')
  void onRemovedSectionFromCl (CustomEvent event, details) {
    if (null != details['crossListing']) {
      _removalCleanup (details['crossListing'] as CrossListing);
    };
  }

  /// The [onConfirmClSets] method...
  @Listen('tap')
  void onConfirmClSets (CustomEvent event, details) {
    if ('confirmClSetsButton' == (Polymer.dom (event)).localTarget.id) {
      _confirmCrossListings();
    }
  }

  /// The [onConfirmClSetsFromCl] method...
  @Listen('confirm-cl-sets-from-cl')
  void onConfirmClSetsFromCl (CustomEvent event, details) => _confirmCrossListings();

  /// The [_confirmCrossListings] method...
  void _confirmCrossListings() {
    this.fire ('iron-signal', detail: {
      'name': 'cross-listings-specified',
      'data': {'section': currentSection, 'crossListings': crossListings}
    });
  }

  /// The [_removalCleanup] method...
  void _removalCleanup (CrossListing crossListing) {
    if (1 < crossListings.length) {
      removeWhere ('crossListings',
        (CrossListing aCrossListing) => (1 > aCrossListing.sections.length) ? true : false
      );
    }

    updateView();
  }

  /// The [updateView] method...
  void updateView() {
    notifyPath ('crossListings', crossListings);

    _clDialog
      ..refit()
      ..center();
  }
}
