@HtmlImport('simple_loader.html')
library plato_elements.simple_loader;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

/// The [SimpleLoader] class...
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

  /// The [loadTypedData] method...
  void loadTypedData ({bool isPost: true}) {
    _loaderAjax ??= $['loader-ajax'] as IronAjax;

    // Prevent double loading, when already attempting to load the same request.
    if (_loaderAjax.loading) {
      return;
    }

    if (isPost) {
      _loaderAjax
        ..method = 'POST'
        ..contentType = 'application/x-www-form-urlencoded';
    } else {
      _loaderAjax
        ..method = 'GET'
        ..contentType = 'application/json';
    }

    _loaderAjax.generateRequest();
  }

  @Listen('type-changed')
  void typeChanged (event, details) {
    loadTypedData();
  }

  /// The [handleLoadResponse] method...
  @Listen('response')
  void handleLoadResponse (event, [_]) {
    this.fire ('${type.toLowerCase()}-loaded', detail: _loaderAjax.lastResponse);
  }
}
