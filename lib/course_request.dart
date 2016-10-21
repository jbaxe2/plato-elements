@HtmlImport('course_request.html')
library plato.elements.request.course;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_pages.dart';

import 'package:polymer_elements/paper_drawer_panel.dart';
import 'package:polymer_elements/paper_header_panel.dart';
import 'package:polymer_elements/paper_tabs.dart';
import 'package:polymer_elements/paper_tab.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/paper_toolbar.dart';

import 'cross_listing_views_collection.dart';
import 'learn_authentication_widget.dart';
import 'previous_content_selector.dart';
import 'section_views_collection.dart';

/// Silence analyzer:
/// [IronPages]
///
/// [PaperDrawerPanel] - [PaperHeaderPanel] - [PaperToolbar] - [PaperToast]
/// [PaperTabs] - [PaperTab]
///
/// [CrossListingViewsCollection] - [LearnAuthenticationWidget]
/// [PreviousContentSelector] - [SectionViewsCollection]
///
/// The [CourseRequest] class...
@PolymerRegister('course-request')
class CourseRequest extends PolymerElement {
  @Property(notify: true)
  int selected;

  PaperToast _navToast;

  /// The [CourseRequest] factory constructor...
  factory CourseRequest() => document.createElement ('course-request');

  /// The [CourseRequest] named constructor...
  CourseRequest.created() : super.created();

  /// The [attached] method...
  void attached() {
    notifyPath ('selected', selected = 0);

    _navToast = $['navigation-toast'] as PaperToast;
  }

  /// The [onUserRetrievedComplete] method...
  @Listen('iron-signal-user-retrieved-complete')
  void onUserRetrievedComplete (CustomEvent event, details) {
    _navToast.open();
  }
}
