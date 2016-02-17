@HtmlImport('banner_term.html')
library plato_elements.lib.banner_term;

import 'dart:html' show document;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

@PolymerRegister('banner-term')
class BannerTerm extends PolymerElement {
  @property
  String termId;

  @property
  String description;

  /// The [BannerTerm] factory constructor.
  factory BannerTerm() => document.createElement ('banner-term');

  /// The [BannerTerm] constructor.
  BannerTerm.created() : super.created();
}
