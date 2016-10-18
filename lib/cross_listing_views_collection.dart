@HtmlImport('cross_listing_views_collection.html')
library plato.elements.collection.view.cross_listing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show BannerSection, CrossListing;

/// The [CrossListingViewsCollection] class...
@PolymerRegister('cross-listing-views-collection')
class CrossListingViewsCollection extends PolymerElement {
  /// The [CrossListingViewsCollection] factory constructor...
  factory CrossListingViewsCollection() => document.createElement ('cross-listing-views-collection');

  /// The [CrossListingViewsCollection] named constructor...
  CrossListingViewsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {}
}
