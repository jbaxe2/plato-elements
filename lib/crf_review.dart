@HtmlImport('crf_review.html')
library plato.elements.crf.review;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_material.dart';

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

import 'data_models.dart';

/// Silence analyzer:
/// [IronSignals]
///
/// [PaperButton] - [PaperDialogScrollable] - [PaperItem] - [PaperMaterial]
///
/// [FadeInAnimation] - [FadeOutAnimation]
///
/// The [CrfReview] class...
@PolymerRegister('crf-review')
class CrfReview extends PolymerElement {
  PaperDialog _crfReviewDialog;

  /// The user information...
  @Property(notify: true)
  UserInformation get userInfo => _userInfo;

  UserInformation _userInfo;

  /// The [BannerSection] instances respective of requested courses.
  @Property(notify: true)
  List<BannerSection> get sections => _sections;

  List<BannerSection> _sections;

  /// The [CrossListing] sets for cross-listed courses in the request.
  @Property(notify: true)
  List<CrossListing> get crossListings => _crossListings;

  List<CrossListing> _crossListings;

  /// The requested sections, with previous content and cross-listing information.
  @Property(notify: true)
  List<RequestedSection> get requestedSections => _requestedSections;

  List<RequestedSection> _requestedSections;

  /// The [CrfReview] factory constructor...
  factory CrfReview() => document.createElement ('crf-review');

  /// The [CrfReview] named constructor...
  CrfReview.created() : super.created();

  /// The [attached] method...
  void attached() {
    _sections = new List<BannerSection>();
    _crossListings = new List<CrossListing>();
    _requestedSections = new List<RequestedSection>();

    _crfReviewDialog = $['crf-review-dialog'] as PaperDialog;
  }

  /// The [onCollectInfoCrfReview] method...
  @Listen('iron-signal-collect-info-crf-review')
  void onCollectInfoCrfReview (CustomEvent event, details) {
    _crfReviewDialog.open();
  }

  /// The [onCollectUserInfo] method...
  @Listen('iron-signal-collect-user-info')
  void onCollectUserInfo (CustomEvent event, details) {
    if (null != details['userInfo']) {
      _userInfo = details['userInfo'] as UserInformation;

      notifyPath ('userInfo', _userInfo);
    }
  }

  /// The [onCollectSectionsInfo] method...
  @Listen('iron-signal-collect-sections-info')
  void onCollectSectionsInfo (CustomEvent event, details) {
    if (null != details['sections']) {
      _sections = details['sections'] as List<BannerSection>;

      notifyPath ('sections', _sections);
    }
  }

  /// The [onCollectCrossListingsInfo] method...
  @Listen('iron-signal-collect-cross-listings-info')
  void onCollectCrossListingsInfo (CustomEvent event, details) {
    if (null != details['crossListings']) {
      _crossListings = details['crossListings'] as List<CrossListing>;

      notifyPath ('crossListings', _crossListings);
    }
  }

  /// The [onCollectRequestedSectionInfo] method...
  @Listen('iron-signal-collect-requested-section-info')
  void onCollectRequestedSectionInfo (CustomEvent event, details) {
    if (null != details['requestedSection']) {
      var requestedSection = details['requestedSection'] as RequestedSection;

      _requestedSections.add (requestedSection);

      notifyPath ('requestedSections', _requestedSections);
    }
  }

  /// The [submitCourseRequest] method...
  @Listen('tap')
  void submitCourseRequest (CustomEvent event, details) {
    if ('submit-crf-button' == (Polymer.dom (event)).localTarget.id) {
      window.console.log ('clicked to submit the crf');
    }
  }
}
