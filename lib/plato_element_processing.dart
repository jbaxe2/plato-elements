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
  PaperDialog _progress;

  /// The [PlatoElementProcessing] factory constructor...
  factory PlatoElementProcessing() => document.createElement ('plato-element-processing');

  /// The [PlatoElementProcessing] named constructor...
  PlatoElementProcessing.created() : super.created();

  /// The [attached] method...
  void attached() {
    _progress = $['progress-dialog'] as PaperDialog;
  }

  /// The [onShowProgressBar] method...
  @Listen('iron-signal-show-progress')
  void onShowProgressBar (CustomEvent event, details) {
    _progress
      ..refit()
      ..center()
      ..open();
  }

  /// The [onHideProgressBar] method...
  @Listen('iron-signal-hide-progress')
  void onHideProgressBar (CustomEvent event, details) {
    _progress.close();
  }
}
