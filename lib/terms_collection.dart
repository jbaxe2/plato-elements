@HtmlImport('terms_collection.html')
library plato.elements.collection.terms;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show LearnTerm;
import 'simple_retriever.dart';

/// The [TermsCollection] element class...
@PolymerRegister('terms-collection')
class TermsCollection extends PolymerElement {
  /// The [List] of [LearnTerm] instances.
  @Property(notify: true)
  List<LearnTerm> terms;

  /// The [SimpleRetriever] element...
  SimpleRetriever _retriever;

  /// The [TermsCollection] factory constructor.
  factory TermsCollection() => document.createElement ('terms-collection');

  /// The [TermsCollection] constructor.
  TermsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    terms = new List<LearnTerm>();

    (_retriever ??= $['terms-retriever'] as SimpleRetriever)
      ..retrieveTypedData();
  }

  /// The [onTermsRetrieved] method...
  @Listen('terms-retrieved')
  void onTermsRetrieved (CustomEvent event, details) {
    if (null != details['terms']) {
      try {
        details['terms'].forEach ((termDetails) {
          var term = new LearnTerm (termDetails['id'], termDetails['description']);

          async (() => add ('terms', term));
        });

        notifyPath ('terms', terms);
      } catch (_) {}
    }
  }
}
