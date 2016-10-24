@HtmlImport('cross_listing_view.html')
library plato.elements.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show BannerSection, CrossListing;

/// The [CrossListingView] class...
@PolymerRegister('cross-listing-view')
class CrossListingView extends PolymerElement {
  @Property(notify: true)
  CrossListing crossListing;

  @Property(notify: true)
  int clSetNumber;

  @Property(notify: true)
  bool haveSections;

  /// The [CrossListingView] factory constructor.
  factory CrossListingView() => document.createElement ('cross-listing-view');

  /// The [CrossListingView] named constructor.
  CrossListingView.created() : super.created();

  /// The [attached] method...
  void attached() {
    notifyPath ('haveSections', haveSections = false);

    if (null == crossListing) {
      crossListing = new CrossListing();
    }
  }

  /// The [onAddSectionToCrossListing] method...
  @Listen('cross-listing-selected')
  void onAddSectionToCrossListing (CustomEvent event, details) {
    if (null != details['section']) {
      var section = details['section'] as BannerSection;

      crossListing.addSection (section);

      notifyPath ('crossListing', crossListing);
      notifyPath ('haveSections', haveSections = true);
    }
  }

  /// The [onSectionAddedToCrossListing] method...
  @Listen('cross-listing-added')
  void onSectionAddedToCrossListing (CustomEvent event, details) {
    ;
  }
}
