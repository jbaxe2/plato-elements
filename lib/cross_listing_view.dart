@HtmlImport('cross_listing_view.html')
library plato.elements.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show BannerSection, CrossListing;

/// Silence analyzer:
/// [BannerSection]
///
/// The [CrossListingView] class...
@PolymerRegister('cross-listing-view')
class CrossListingView extends PolymerElement {
  @Property(notify: true)
  CrossListing crossListing;

  @Property(notify: true)
  int clSetNumber;

  /// The [CrossListingView] factory constructor.
  factory CrossListingView() => document.createElement ('cross-listing-view');

  /// The [CrossListingView] named constructor.
  CrossListingView.created() : super.created();

  /// The [attached] method...
  void attached() {
    if (null == crossListing) {
      crossListing = new CrossListing();
    }
  }
}
