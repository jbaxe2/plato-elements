@HtmlImport('cross_listing_view.html')
library plato_elements.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show BannerSection, CrossListing;

/// The [CrossListingView] class...
@PolymerRegister('cross-listing-view')
class CrossListingView extends PolymerElement {
  @Property(notify: true)
  CrossListing crossListing;

  /// The [CrossListingView] factory constructor.
  factory CrossListingView() => document.createElement ('cross-listing-view');

  /// The [CrossListingView] named constructor.
  CrossListingView.created() : super.created();

  /// The [attached] method...
  void attached() {
    crossListing = new CrossListing();
  }

  /// The [onSectionAddedToCL] method...
  @Listen('iron-signal-section-added-to-cross-listing')
  void onSectionAddedToCL (CustomEvent event, details) {
    ;
  }
}
