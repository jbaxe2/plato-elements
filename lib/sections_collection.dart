@HtmlImport('sections_collection.html')
library plato.elements.collection.sections;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';

import 'data_models.dart' show BannerSection;
import 'simple_retriever.dart';

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

  /// The [SimpleRetriever] element...
  SimpleRetriever _retriever;

  /// The [SectionsCollection] factory constructor.
  factory SectionsCollection() => document.createElement ('sections-collection');

  /// The [SectionsCollection] constructor.
  SectionsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    sections = new List<BannerSection>();

    _retriever ??= $['sections-retriever'] as SimpleRetriever;
  }

  /// The [courseAndTermChanged] method...
  @Observe('courseId, termId')
  void courseAndTermChanged (String newCourseId, String newTermId) {
    _retriever.retrieveTypedData (
      data: {'course': courseId, 'term': termId}
    );
  }

  /// The [onCourseSelected] method...
  @Listen('iron-signal-course-selected')
  void onCourseSelected (CustomEvent event, details) {
    if (null != details['course']) {
      var _courseId = details['course'];

      if (8 < _courseId.length) {
        _courseId = _courseId.substring (0, (_courseId.length - 3));
      }

      courseId = _courseId;

      notifyPath ('courseId', courseId);
    }
  }

  /// The [onTermSelected] method...
  @Listen('iron-signal-term-selected')
  void onTermSelected (CustomEvent event, details) {
    if (null != details['term']) {
      termId = details['term'];
    }

    notifyPath ('termId', termId);
  }

  /// The [onSectionsRetrieved] method...
  @Listen('sections-retrieved')
  void onSectionsRetrieved (CustomEvent event, details) {
    if (null != details['sections']) {
      sections = new List<BannerSection>();

      details['sections'].forEach ((sectionDetails) {
        BannerSection section = new BannerSection (
          sectionDetails['crsno'], sectionDetails['crn'], sectionDetails['title'],
          sectionDetails['facname'], sectionDetails['mtime'],
          sectionDetails['mplace'], sectionDetails['term']
        );

        sections.add (section);
      });

      notifyPath ('sections', sections);

      this.fire ('iron-signal', detail: {
        'name': 'sections-retrieved-complete', 'data': null
      });
    }
  }
}
