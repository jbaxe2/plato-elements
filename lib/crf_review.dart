@HtmlImport('crf_review.html')
library plato.elements.crf.review;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_material.dart';

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

import 'data_models.dart';

/// Silence analyzer:
/// [IronSignals]
/// [FadeInAnimation] - [FadeOutAnimation]
/// [PaperDialog] - [PaperItem] - [PaperMaterial]
///
/// The [CrfReview] class...
@PolymerRegister('crf-review')
class CrfReview extends PolymerElement {
  PaperDialog _crfReviewDialog;

  /// The user information...
  UserInformation get userInfo => _userInfo;

  UserInformation _userInfo;

  /// The [BannerSection] instances corresponding to requested courses...
  List<BannerSection> get sections => _sections;

  List<BannerSection> _sections;

  /// The [CrossListing] sets for cross-listed courses in the request.
  List<CrossListing> get crossListings => _crossListings;

  List<CrossListing> _crossListings;

  /// The requested sections, with previous content and cross-listing information.
  List<RequestedSection> get requestedSections => _requestedSections;

  List<RequestedSection> _requestedSections;

  /// The [CrfReview] factory constructor...
  factory CrfReview() => document.createElement ('crf-review');

  /// The [CrfReview] named constructor...
  CrfReview.created() : super.created();

  /// The [attached] method...
  void attached() {
    _crfReviewDialog = $['crf-review-dialog'] as PaperDialog;

    _sections = new List<BannerSection>();
    _crossListings = new List<CrossListing>();
    _requestedSections = new List<RequestedSection>();
  }

  /// The [onShowCrfReview] method...
  @Listen('iron-signal-collect-info-crf-review')
  void onShowCrfReview (CustomEvent event, details) {
    window.console.log ('got into the show crf review event handler...why does it not display??');

    _crfReviewDialog.open();
  }

  /// The [onCollectUserInfo] method...
  @Listen('iron-signal-collect-user-info')
  void onCollectUserInfo (CustomEvent event, details) {
    if (null != details['userInfo']) {
      notifyPath ('userInfo', _userInfo = details['userInfo'] as UserInformation);
    }
  }

  /// The [onCollectSectionsInfo] method...
  @Listen('iron-signal-collect-sections-info')
  void onCollectSectionsInfo (CustomEvent event, details) {
    if (null != details['sections']) {
      notifyPath ('sections', _sections = details['sections'] as List<BannerSection>);
    }
  }

  /// The [onCollectCrossListingsInfo] method...
  @Listen('iron-signal-collect-cross-listings-info')
  void onCollectCrossListingsInfo (CustomEvent event, details) {
    if (null != details['crossListings']) {
      notifyPath ('crossListings', _crossListings = details['crossListings'] as List<CrossListing>);
    }
  }

  /// The [onCollectRequestedSectionInfo] method...
  @Listen('iron-signal-collect-requested-section-info')
  void onCollectRequestedSectionInfo (CustomEvent event, details) {
    if (null != details['requestedSection']) {
      _requestedSections.add (details['requestedSection'] as RequestedSection);

      notifyPath ('requestedSections', _requestedSections);
    }
  }
}
