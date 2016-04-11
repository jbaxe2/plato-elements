@HtmlImport('sections_collection.html')
library plato_elements.sections_collection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'data_models.dart' show BannerSection;
import 'simple_loader.dart';

/// Silence analyzer [IronSignals]
///
/// The [SectionsCollection] element class...
@PolymerRegister('sections-collection')
class SectionsCollection extends PolymerElement {
  /// The ID of the course associated with the section(s).
  @Property(notify: true)
  String courseId;

  /// The ID of the term associated with the section(s).
  @Property(notify: true)
  String termId;

  /// The [List] of [BannerSection] instances.
  @Property(notify: true)
  List<BannerSection> sections;

  /// The [SimpleLoader] element...
  SimpleLoader _loader;

  /// The [SectionsCollection] factory constructor.
  factory SectionsCollection() => document.createElement ('sections-collection');

  /// The [SectionsCollection] constructor.
  SectionsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    sections = new List<BannerSection>();

    _loader ??= $['sections-loader'] as SimpleLoader;
  }

  /// The [updateCourseAndTerm] method...
  @Observe('courseId, termId')
  void updateCourseAndTerm (String newCourseId, String newTermId) {
    _loader.loadTypedData (
      isPost: false, data: {'course': courseId, 'term': termId}
    );
  }

  /// The [handleCourseSelected] method...
  @Listen('iron-signal-course-selected')
  void handleCourseSelected (CustomEvent event, details) {
    if (null != details['course']) {
      var _courseId = details['course'];

      if (8 < _courseId.length) {
        _courseId = _courseId.substring (0, (_courseId.length - 3));
      }

      courseId = _courseId;

      notifyPath ('courseId', courseId);
    }
  }

  /// The [handleTermSelected] method...
  @Listen('iron-signal-term-selected')
  void handleTermSelected (CustomEvent event, details) {
    if (null != details['term']) {
      termId = details['term'];
    }

    notifyPath ('termId', termId);
  }

  /// The [handleSectionsLoaded] method...
  @Listen('sections-loaded')
  void handleSectionsLoaded (CustomEvent event, details) {
    if (null != details['sections']) {
      details['sections'].forEach ((sectionDetails) {
        BannerSection section = new BannerSection (
          sectionDetails['crsno'], sectionDetails['crn'], sectionDetails['title'],
          sectionDetails['facname'], sectionDetails['mtime'],
          sectionDetails['mplace'], sectionDetails['term']
        );

        sections.add (section);
      });

      notifyPath ('sections', sections);
    }
  }
}
