@HtmlImport('simple_retriever.html')
library plato.elements.retriever.simple;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

import 'plato_elements_utils.dart';

/// The [SimpleRetriever] element class...
@PolymerRegister('simple-retriever')
class SimpleRetriever extends PolymerElement {
  /// The type of retriever, to be configured by elements using an instance of this
  /// element in aggregate.
  @Property(notify: true)
  String type;

  /// The [IronAjax] instance for loading some data from the server.
  IronAjax _retrieverAjax;

  /// The [SimpleRetriever] factory constructor...
  factory SimpleRetriever() => document.createElement ('simple-retriever');

  /// The [SimpleRetriever] named constructor...
  SimpleRetriever.created() : super.created();

  /// The [retrieveTypedData] method is used to load the data of some particular
  /// type, via an Ajax-based request.  A request will not be sent if there is
  /// a previous request already in progress.
  void retrieveTypedData ({bool isPost: false, Map<String,String> data}) {
    _retrieverAjax ??= $['retriever-ajax'] as IronAjax;

    // Prevent double loading, when already attempting to load the same request.
    if (_retrieverAjax.loading) {
      return;
    }

    if (isPost) {
      _retrieverAjax
        ..method = 'POST'
        ..contentType = 'application/x-www-form-urlencoded'
        ..body = data;
    } else {
      _retrieverAjax
        ..method = 'GET'
        ..contentType = 'application/json';

      if (0 < data?.length) {
        _retrieverAjax.params = data;
      }
    }

    _retrieverAjax.generateRequest();
  }

  // The [typeChanged] method...
  //@Listen('type-changed')
  //void typeChanged (event, details) => retrieveTypedData();

  /// The [onRetrieveResponse] method...
  @Listen('response')
  void onRetrieveResponse (event, [_]) {
    var response = _retrieverAjax.lastResponse;

    if (null != response['error']) {
      raiseError (this, 'Server information load error', response['error']);

      //this.fire (
      //  'iron-signal', detail: {'name': 'error', 'data': response}
      //);
    } else if (null != response[type]) {
      this.fire ('${type.toLowerCase()}-retrieved', detail: response);
    }
  }
}
