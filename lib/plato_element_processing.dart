@HtmlImport('plato_element_processing.html')
library plato.elements.processing;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_progress.dart';

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

/// Silence analyzer:
/// [IronSignals] - [PaperProgress]
/// [FadeInAnimation] - [FadeOutAnimation]
///
/// The [PlatoElementProcessing] class...
@PolymerRegister('plato-element-processing')
class PlatoElementProcessing extends PolymerElement {
  @Property(notify: true)
  String message;

  PaperDialog _progress;

  final String _message = 'Please wait; this may take a few moments...';

  /// The [PlatoElementProcessing] factory constructor...
  factory PlatoElementProcessing() => document.createElement ('plato-element-processing');

  /// The [PlatoElementProcessing] named constructor...
  PlatoElementProcessing.created() : super.created();

  /// The [attached] method...
  void attached() {
    _progress = $['progress-dialog'] as PaperDialog;

    set ('message', _message);
  }

  /// The [onShowProgressBar] method...
  @Listen('iron-signal-show-progress')
  void onShowProgressBar (CustomEvent event, details) {
    if (null != details['message']) {
      set ('message', details['message']);
    }

    _progress
      ..refit()
      ..center()
      ..open();
  }

  /// The [onHideProgressBar] method...
  @Listen('iron-signal-hide-progress')
  void onHideProgressBar (CustomEvent event, details) {
    _progress.close();

    set ('message', _message);
  }
}
