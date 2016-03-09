@HtmlImport('banner_section.html')
library plato_elements.banner_section;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

/// The [BannerSection] element class...
@PolymerRegister('banner-section')
class BannerSection extends PolymerElement {
  @Property(notify: true)
  String sectionId;

  @Property(notify: true)
  String crn;

  @Property(notify: true)
  String courseTitle;

  @Property(notify: true)
  String faculty;

  @Property(notify: true)
  String time;

  @Property(notify: true)
  String place;

  @Property(notify: true)
  String termId;

  /// The [BannerSection] factory constructor.
  factory BannerSection() => document.createElement ('banner-section');

  /// The [BannerSection] named constructor.
  BannerSection.created() : super.created();
}
