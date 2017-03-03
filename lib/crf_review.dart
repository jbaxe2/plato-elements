@HtmlImport('crf_review.html')
library plato.elements.crf.review;

import 'dart:html';

import 'package:polymer_elements/iron_signals.dart';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

/// Silence analyzer:
/// [IronSignals]
///
/// The [CrfReview] class...
@PolymerRegister('crf-review')
class CrfReview extends PolymerElement {
  /// The [CrfReview] factory constructor...
  factory CrfReview() => document.createElement ('crf-review');

  /// The [CrfReview] named constructor...
  CrfReview.created() : super.created();

  /// The [attached] method...
  void attached() {}

  /// The [onCollectCrossListingsInfo] method...
  @Listen('iron-signal-collect-cross-listings-info')
  void onCollectCrossListingsInfo (CustomEvent event, details) {
    ;
  }

  /// The [onCollectSectionsInfo] method...
  @Listen('iron-signal-collect-sections-info')
  void onCollectSectionsInfo (CustomEvent event, details) {
    ;
  }

  /// The [onCollectUserInfo] method...
  @Listen('iron-signal-collect-user-info')
  void onCollectUserInfo (CustomEvent event, details) {
    ;
  }
}
