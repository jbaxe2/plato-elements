@HtmlImport('terms_collection.html')
library plato_elements.terms_collection;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'data_models.dart' show BannerTerm;
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

  /// The [onTermsLoaded] method...
  @Listen('terms-loaded')
  void onTermsLoaded (CustomEvent event, details) {
    if (null != details['terms']) {
      try {
        details['terms'].forEach ((termDetails) {
          BannerTerm term = new BannerTerm (
            termDetails['id'], termDetails['description']
          );

          async (() {
            add ('terms', term);
          });
        });

        notifyPath ('terms', terms);
      } catch (_) {}
    }
  }
}
