@HtmlImport('cross_listing_views_collection.html')
library plato.elements.collection.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/iron_icons.dart';

import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_dialog.dart';

import 'data_models.dart' show BannerSection, CrossListing;

import 'cross_listing_view.dart';
import 'section_view.dart';

/// Silence analyzer:
/// [IronSignals] - [PaperIconButton] - [CrossListingView]
///
/// The [CrossListingViewsCollection] class establishes the potential collection
/// of one or more cross-listing set views.  Interactions with cross-listing sets
/// are done though the context of a 'current' section (and its associated view).
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

  /// The [attached] method initializes configurations needed for this element,
  /// once it has been added to the DOM via some other element.
  void attached() {
    set ('crossListings', new List<CrossListing>());

    _clDialog = $['cross-listing-dialog'] as PaperDialog;
  }

  /// The [onShowCrossListingSelector] method listens for the display of the view
  /// allowing for changing the cross-listing options.  This view is established
  /// based on a 'current' section for the context of cross-listing that section
  /// with others.
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

  /// The [addNewClSet] method listens for the means to add a new cross-listing
  /// set to this collection, provided that none of the cross-listing sets already
  /// established are empty.
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

  /// The [onRemoveCrossListingSet] method listens for the removal of a specific
  /// cross-listing set from the collection.
  @Listen('remove-cross-listing-set')
  void onRemoveCrossListingSet (CustomEvent event, details) {
    if (null != details['crossListing']) {
      var crossListing = details['crossListing'] as CrossListing;

      removeItem ('crossListings', crossListing);

      _removalCleanup (crossListing);
    }
  }

  /// The [onRemovedSectionFromCl] method listens for the removal of a section
  /// from a cross-listing set that belongs to the collection, in which the
  /// section removal has already taken place.
  @Listen('removed-section-from-cl')
  void onRemovedSectionFromCl (CustomEvent event, details) {
    if (null != details['crossListing']) {
      _removalCleanup (details['crossListing'] as CrossListing);
    };
  }

  /// The [onConfirmClSets] method listens for the user to signify that any changes
  /// made to the cross-listing sets in the collection have been established.
  @Listen('tap')
  void onConfirmClSets (CustomEvent event, details) {
    if ('confirmClSetsButton' == (Polymer.dom (event)).localTarget.id) {
      _confirmCrossListings();
    }
  }

  /// The [onConfirmClSetsFromCl] method listens for a signal that cross-listing
  /// sets have been confirmed, whereby this confirmation comes from some change
  /// in a particular cross-listing set as opposed to the user.
  @Listen('confirm-cl-sets-from-cl')
  void onConfirmClSetsFromCl (CustomEvent event, details) => _confirmCrossListings();

  /// The [_confirmCrossListings] method signifies that changes with any and all
  /// cross-listing sets have been confirmed, in the context of the 'current'
  /// section.
  void _confirmCrossListings() {
    this.fire ('iron-signal', detail: {
      'name': 'cross-listings-specified',
      'data': {'section': currentSection, 'crossListings': crossListings}
    });
  }

  /// The [_removalCleanup] method removes a cross-listing set from the collection
  /// if all of the sections have been removed from that set.
  void _removalCleanup (CrossListing crossListing) {
    if (1 < crossListings.length) {
      removeWhere ('crossListings',
        (CrossListing aCrossListing) => (1 > aCrossListing.sections.length) ? true : false
      );
    }

    updateView();
  }

  /// The [updateView] method simply refreshes the path for whatever cross-listing
  /// sets may be established, and then re-sizes and re-centers the view.
  void updateView() {
    notifyPath ('crossListings', crossListings);

    _clDialog
      ..refit()
      ..center();
  }

  /// The [onCollectInfoCrfReview] method...
  @Listen('iron-signal-collect-info-crf-review')
  void onCollectInfoCrfReview (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {
      'name': 'iron-signal-collect-cross-listings-info',
      'data': {'crossListings': crossListings}
    });
  }
}
