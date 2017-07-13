@HtmlImport('crf_directions.html')
library plato.elements.crf.directions;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_collapse.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_material.dart';

/// Silence analyzer:
/// [PaperButton] - [PaperMaterial]
///
/// The [CrfDirections] class...
@PolymerRegister('crf-directions')
class CrfDirections extends PolymerElement {
  IronCollapse _collapser;

  /// The [CrfDirections] factory constructor...
  factory CrfDirections() => document.createElement ('crf-directions');

  /// The [CrfDirections] named constructor...
  CrfDirections.created() : super.created();

  /// The [attached] method...
  void attached() {
    _collapser = $['directions-collapser'] as IronCollapse;
  }

  /// The [onToggleDirections] method...
  @Listen('tap')
  void onToggleDirections (CustomEvent event, details) {
    if ('collapser-button' == (Polymer.dom (event)).localTarget.id) {
      _collapser.toggle();
    }
  }
}
