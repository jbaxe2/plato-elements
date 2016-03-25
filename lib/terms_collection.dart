@HtmlImport('terms_collection.html')
library plato_elements.terms_collection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'banner_term.dart';
import 'simple_loader.dart';

/// The [TermsCollection] element class...
@PolymerRegister('terms-collection')
class TermsCollection extends PolymerElement {
  /// The [List] of [BannerTerm] instances.
  @Property(notify: true)
  List<BannerTerm> terms;

  /// The [SimpleLoader] element...
  SimpleLoader _loader;

  /// The [TermsCollection] factory constructor.
  factory TermsCollection() => document.createElement ('terms-collection');

  /// The [TermsCollection] constructor.
  TermsCollection.created() : super.created();

  /// The [attached] method...
  void attached() {
    terms = new List<BannerTerm>();

    (_loader ??= $['terms-loader'] as SimpleLoader)
      ..loadTypedData (isPost: false);
  }

  /// The [handleTermsLoaded] method...
  @Listen('terms-loaded')
  void handleTermsLoaded (CustomEvent event, details) {
    if (null != details['terms']) {
      details['terms'].forEach ((termDetails) {
        BannerTerm term = new BannerTerm()
          ..termId = termDetails['id']
          ..description = termDetails['description'];

        terms.add (term);
      });

      notifyPath ('terms', terms);

      this.fire ('terms-loaded-completed');
    }
  }
}
