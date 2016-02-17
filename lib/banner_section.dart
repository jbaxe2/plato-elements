@HtmlImport('banner_section.html')
library plato_elements.lib.banner_section;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

@PolymerRegister('banner-section')
class BannerSection extends PolymerElement {
  @property
  String sectionId;

  @property
  String crn;

  @property
  String courseTitle;

  @property
  String faculty;

  @property
  String time;

  @property
  String place;

  @property
  String termId;

  /// The [BannerSection] factory constructor.
  factory BannerSection() => document.createElement ('banner-section');

  /// The [BannerSection] named constructor.
  BannerSection.created() : super.created();
}
