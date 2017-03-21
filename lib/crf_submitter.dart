@HtmlImport('crf_submitter.html')
library plato.elements.crf.submitter;

import 'dart:convert';
import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_signals.dart';

import 'data_models.dart';
import 'plato_elements_utils.dart';

/// Silence analyzer: [IronSignals]
///
/// The [CrfSubmitter] class...
@PolymerRegister('crf-submitter')
class CrfSubmitter extends PolymerElement {
  /// The user information...
  @Property(notify: true)
  UserInformation userInfo;

  /// The [BannerSection] instances respective of requested courses.
  @Property(notify: true)
  List<BannerSection> sections;

  /// The [CrossListing] sets for cross-listed courses in the request.
  @Property(notify: true)
  List<CrossListing> crossListings;

  @Property(notify: true)
  bool get haveCrossListings => _haveCrossListings;

  bool _haveCrossListings = false;

  /// The requested sections, with previous content and cross-listing information.
  @Property(notify: true)
  List<RequestedSection> requestedSections;

  IronAjax _crfSubmitterAjax;

  /// The [CrfSubmitter] factory constructor...
  factory CrfSubmitter() => document.createElement ('crf-review');

  /// The [CrfSubmitter] named constructor...
  CrfSubmitter.created() : super.created();

  /// The [attached] method...
  void attached() {
    set ('sections', new List<BannerSection>());
    set ('crossListings', new List<CrossListing>());
    set ('requestedSections', new List<RequestedSection>());
  }

  /// The [onCrfSubmission] method...
  @Listen('iron-signal-crf-submission')
  void onCrfSubmission (CustomEvent event, details) {
    if ((null == details['userInfo']) || (null == details['sections']) ||
        (null == details['crossListings']) || (null == details['requestedSections'])) {
      raiseError (this,
        'Insufficient submission error',
        'An attempt was made to submit the course request, but required information is missing.'
      );
    }

    Map<String, dynamic> crfInfo;

    try {
      crfInfo = {
        'userInfo': JSON.encode (details['userInfo'] as UserInformation),
        'sections': JSON.encode (details['sections'] as List<BannerSection>),
        'crossListings': JSON.encode (details['crossListings'] as List<CrossListing>),
        'requestedSections': JSON.encode (details['requestedSections'] as List<RequestedSection>)
      };
    } catch (_) {
      raiseError (this,
        'Corrupted submission error',
        'Provided course request information is not appropriate for submission.'
      );

      return;
    }

    _crfSubmitterAjax = $['crf-submitter-ajax'] as IronAjax
      ..method = 'POST'
      ..contentType = 'application/json'
      ..body = crfInfo
      ..generateRequest();

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});
  }

  /// The [onCrfSubmissionResponse] method...
  @Listen('response')
  void onCrfSubmissionResponse (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    var crfResponse = _crfSubmitterAjax.lastResponse;

    window.console.debug (crfResponse);
  }
}
