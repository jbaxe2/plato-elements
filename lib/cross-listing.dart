@HtmlImport('cross-listing.html')
library plato_elements.lib.cross_listing;

import 'dart:html' show document;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

//import 'banner_section.dart';

@PolymerRegister('cross-listing')
class CrossListing extends PolymerElement {
  //Map<String, BannerSection> _bannerSections;

  @Property(observer: 'sectionIdsChanged')
  String sectionIds;

  /// The [CrossListing] constructor.
  CrossListing.created() : super.created();

  /// The [CrossListing] factory constructor.
  factory CrossListing() => document.createElement ('cross-listing');

  @reflectable
  void sectionIdsChanged (String newSectionIds, String oldSectionIds) {
    List<String> sectionIds = newSectionIds.split (' ');
    List<String> prevSectionIds = oldSectionIds.split (' ');
  }
}
