@HtmlImport('plato_element_error.html')
library plato.elements.error;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/paper_dialog.dart';

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

/// Silence analyzer:
/// [IronIcon] - [IronSignals] - [FadeInAnimation] - [FadeOutAnimation]
///
/// The [PlatoElementError] class...
@PolymerRegister('plato-element-error')
class PlatoElementError extends PolymerElement {
  /// The title pertaining to the error message.
  @Property(notify: true)
  String title;

  /// The error message relating to why we would display this error element.
  @Property(notify: true)
  String message;

  PaperDialog _error;

  /// The [PlatoElementError] factory constructor.
  factory PlatoElementError() => document.createElement ('plato-element-error');

  /// The [PlatoElementError] named constructor.
  PlatoElementError.created() : super.created();

  /// The [attached] method...
  void attached() {
    _error = $['error-dialog'] as PaperDialog;
  }

  /// The [onPlatoError] method...
  @Listen('iron-signal-error')
  void onPlatoError (CustomEvent event, details) {
    if (null != details['error']) {
      var theError = details['error'];

      if (theError is String) {
        set ('title', 'Error!');
        set ('message', theError);
      } else if (theError is Map) {
        if (null != theError['title']) {
          set ('title', theError['title']);
        }

        if (null != theError['message']) {
          set ('message', theError['message']);
        }
      }
    } else {
      set ('title', 'Error!');
      set ('message', 'An unknown error has occurred.');
    }

    /// Resize, center, and display the error dialog.
    _error
      ..refit()
      ..center()
      ..open();
  }
}
