@HtmlImport('crf_review.html')
library plato.elements.crf.review;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

/// The [CrfReview] class...
@PolymerRegister('crf-review')
class CrfReview extends PolymerElement {
  /// The [CrfReview] factory constructor...
  factory CrfReview() => document.createElement ('crf-review');

  /// The [CrfReview] named constructor...
  CrfReview.created() : super.created();

  /// The [attached] method...
  void attached() {}
}
