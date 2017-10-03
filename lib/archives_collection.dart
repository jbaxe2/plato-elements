@HtmlImport('archives_collection.html')
library plato.elements.collection.archives;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show CourseEnrollment;
import 'plato_elements_utils.dart';
import 'simple_retriever.dart';

@PolymerRegister('archives-collection')
class ArchivesCollection extends PolymerElement {
  @Property(notify: true)
  String username;

  @Property(notify: true)
  List<CourseEnrollment> archives;

  SimpleRetriever _retriever;

  /// The [ArchivesCollection] factory constructor.
  factory ArchivesCollection() => document.createElement ('archives-collection');

  /// The [ArchivesCollection] named constructor.
  ArchivesCollection.created() : super.created();

  /// The [attached] constructor...
  void attached() {
    _retriever ??= $['archives-retriever'] as SimpleRetriever;
  }

  /// The [retrieveArchives] method...
  void retrieveArchives() {
    _retriever.retrieveTypedData();
  }

  /// The [onArchivesRetrieved] method...
  @Listen('archives-retrieved')
  void onArchivesRetrieved (CustomEvent event, details) {
    if (null != details['archives']) {
      try {
        set ('archives', new List<CourseEnrollment>());

        details['archives'].forEach ((archiveDetails) {
          if (archiveDetails['learn.user.username'] != username) {
            raiseError (this,
              'Archives retrieval error',
              'The retrieved archives do not match the authenticated user.'
            );
          }

          var archive = new CourseEnrollment (
            archiveDetails['learn.user.username'], archiveDetails['learn.course.id'],
            archiveDetails['learn.course.name'], archiveDetails['learn.membership.role'],
            archiveDetails['learn.membership.available'], isArchive: true
          );

          async (() => add ('archives', archive));
        });

        this.fire ('iron-signal', detail: {
          'name': 'archives-retrieved-complete', 'data': {'archives': archives}
        });
      } catch (_) {}
    }
  }
}
