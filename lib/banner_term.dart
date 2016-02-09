@HtmlImport('banner_term.html')
library plato_elements.lib.banner_term;

import 'dart:html' show document;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('banner-term')
class BannerTerm extends PolymerElement {
  @property
  String termId;

  @property
  String description;

  /// The [BannerTerm] constructor.
  BannerTerm.created() : super.created();

  /// The [BannerTerm] factory constructor.
  factory BannerTerm() => document.createElement ('banner-term');
}
