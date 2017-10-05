@HtmlImport('course_request.html')
library plato.elements.request.course;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_pages.dart';
import 'package:polymer_elements/iron_signals.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_tabs.dart';
import 'package:polymer_elements/paper_tab.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/paper_toolbar.dart';

import 'crf_directions.dart';
import 'crf_response.dart';
import 'crf_review.dart';
import 'crf_submitter.dart';

import 'courses_collection.dart';
import 'departments_collection.dart';
import 'sections_collection.dart';
import 'terms_collection.dart';

import 'course_selector.dart';
import 'department_selector.dart';
import 'sections_selector.dart';
import 'term_selector.dart';

import 'archive_browser.dart';
import 'cross_listing_views_collection.dart';
import 'learn_authentication_widget.dart';
import 'previous_content_selector.dart';
import 'section_views_collection.dart';

import 'session_cleanup.dart';

/// Silence analyzer:
/// [IronIcon] - [IronPages] - [IronSignals]
///
/// [PaperButton] - [PaperDrawerPanel] - [PaperHeaderPanel] - [PaperToolbar]
/// [PaperToast] - [PaperTabs] - [PaperTab]
///
/// [CrfDirections] - [CrfResponse] - [CrfReview] - [CrfSubmitter]
/// [CrossListingViewsCollection] - [ArchiveBrowser]
/// [LearnAuthenticationWidget] - [PreviousContentSelector] - [SectionViewsCollection]
///
/// [DepartmentsCollection] - [TermsCollection] - [CoursesCollection]
/// [SectionsCollection]
///
/// [DepartmentSelector] - [TermSelector] - [CourseSelector] - [SectionsSelector]
///
/// [SessionCleanup]
///
/// The [CourseRequest] class...
@PolymerRegister('course-request')
class CourseRequest extends PolymerElement {
  /// The tab currently selected, either 0 (user information) or 1 (courses selection).
  @Property(notify: true)
  int selected;

  PaperToast _navToast;

  bool _userLoaded = false;

  /// Whether the course request form is submittable.
  @Property(notify: true)
  bool get submittable => _submittable;

  bool _submittable = false;

  @Property(notify: true)
  bool get showCrfReview => _showCrfReview;

  bool _showCrfReview = false;

  /// The [CourseRequest] factory constructor...
  factory CourseRequest() => document.createElement ('course-request');

  /// The [CourseRequest] named constructor...
  CourseRequest.created() : super.created();

  /// The [attached] method...
  void attached() {
    _navToast = $['navigation-toast'] as PaperToast;

    notifyPath ('selected', selected = 0);
  }

  /// The [onUserRetrievedComplete] method...
  @Listen('iron-signal-user-retrieved-complete')
  void onUserRetrievedComplete (CustomEvent event, details) {
    _userLoaded = true;
    _navToast.open();
  }

  /// The [onCourseRequestSubmittable] method...
  @Listen('iron-signal-course-request-submittable')
  void onCourseRequestSubmittable (CustomEvent event, details) {
    if ((null != details['crfSubmittable']) && _userLoaded) {
      notifyPath ('submittable', _submittable = details['crfSubmittable']);
    }
  }

  /// The [onReviewCourseRequest] method...
  @Listen('tap')
  void onReviewCourseRequest (CustomEvent event, details) {
    if ('review-crf-button' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'collect-info-crf-review', 'data': null
      });

      notifyPath ('showCrfReview', _showCrfReview = true);
    }
  }
}
