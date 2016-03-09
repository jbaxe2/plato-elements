@HtmlImport('cross-listing.html')
library plato_elements.cross_listing;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

//import 'banner_section.dart';

/// The [CrossListing] element class...
@PolymerRegister('cross-listing')
class CrossListing extends PolymerElement {
  //Map<String, BannerSection> _bannerSections;

  @Property(observer: 'sectionIdsChanged')
  String sectionIds;

  /// The [CrossListing] factory constructor.
  factory CrossListing() => document.createElement ('cross-listing');

  /// The [CrossListing] constructor.
  CrossListing.created() : super.created();

  @reflectable
  void sectionIdsChanged (String newSectionIds, String oldSectionIds) {
    List<String> sectionIds = newSectionIds.split (' ');
    List<String> prevSectionIds = oldSectionIds.split (' ');
  }
}
