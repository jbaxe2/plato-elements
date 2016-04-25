@HtmlImport('simple_loader.html')
library plato_elements.simple_loader;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

/// The [SimpleLoader] element class...
@PolymerRegister('simple-loader')
class SimpleLoader extends PolymerElement {
  /// The type of loader, to be configured by elements using an instance of this
  /// element in aggregate.
  @Property(notify: true)
  String type;

  /// The [IronAjax] instance for loading some data from the server.
  IronAjax _loaderAjax;

  /// The [SimpleLoader] factory constructor...
  factory SimpleLoader() => document.createElement ('simple-loader');

  /// The [SimpleLoader] named constructor...
  SimpleLoader.created() : super.created();

  /// The [loadTypedData] method is used to load the data of some particular
  /// type, via an Ajax-based request.  A request will not be sent if there is
  /// a previous request already in progress.
  void loadTypedData ({bool isPost: true, Map<String,String> data}) {
    _loaderAjax ??= $['loader-ajax'] as IronAjax;

    // Prevent double loading, when already attempting to load the same request.
    if (_loaderAjax.loading) {
      return;
    }

    if (isPost) {
      _loaderAjax
        ..method = 'POST'
        ..contentType = 'application/x-www-form-urlencoded'
        ..body = data;
    } else {
      _loaderAjax
        ..method = 'GET'
        ..contentType = 'application/json';

      if ((null != data) && (0 < data.length)) {
        _loaderAjax.params = data;
      }
    }

    _loaderAjax.generateRequest();
  }

  /// The [typeChanged] method...
  @Listen('type-changed')
  void typeChanged (event, details) {
    loadTypedData();
  }

  /// The [handleLoadResponse] method...
  @Listen('response')
  void handleLoadResponse (event, [_]) {
    var response = _loaderAjax.lastResponse;

    if (null != response['error']) {
      this.fire (
        'iron-signal', detail: {'name': 'error', 'data': response}
      );
    } else if (null != response[type]) {
      this.fire ('${type.toLowerCase()}-loaded', detail: response);
    }
  }
}
