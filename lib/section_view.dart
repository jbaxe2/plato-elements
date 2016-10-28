@HtmlImport('section_view.html')
library plato.elements.view.section;

import 'dart:html';

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/iron_signals.dart';
import 'package:polymer_elements/av_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_material.dart';

import 'data_models.dart' show BannerSection, CrossListing, PreviousContentMapping;

/// Silence analyzer:
/// [IronSignals] - [PaperCard] - [PaperIconButton] - [PaperMaterial]
///
/// The [SectionView] class...
@PolymerRegister('section-view')
class SectionView extends PolymerElement {
  @Property(notify: true)
  BannerSection section;

  @Property(notify: true)
  PreviousContentMapping withPreviousContent;

  @Property(notify: true)
  bool get hasPreviousContent => _hasPreviousContent;

  bool _hasPreviousContent;

  @Property(notify: true)
  CrossListing withCrossListing;

  @Property(notify: true)
  bool get hasCrossListing => _hasCrossListing;

  bool _hasCrossListing;

  @Property(notify: true)
  bool hasExtraInfo;

  /// The [SectionView] factory constructor.
  factory SectionView() => document.createElement ('section-view');

  /// The [SectionView] named constructor.
  SectionView.created() : super.created();

  /// The [attached] method...
  void attached() {
    notifyPath ('hasExtraInfo', hasExtraInfo = false);
    notifyPath ('hasPreviousContent', _hasPreviousContent = false);
    notifyPath ('hasCrossListing', _hasCrossListing = false);
  }

  /// The [updateSection] method...
  void updateSection (BannerSection newSection) => set ('section', newSection);

  /// The [onCopyContent] method...
  @Listen('tap')
  void onCopyContent (CustomEvent event, details) {
    if ('copyContentIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'show-copy-content-selector', 'data': {'section': section}
      });
    }
  }

  /// The [onAddToClSet] method...
  @Listen('tap')
  void onAddToClSet (CustomEvent event, details) {
    if ('addToClSetIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'show-cross-listing-selector', 'data': {'sectionView': this}
      });
    }
  }

  /// The [onRemoveSection] method...
  @Listen('tap')
  void onRemoveSection (CustomEvent event, details) {
    if ('removeSectionIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'section-removed', 'data': {'section': section}
      });
    }
  }

  /// The [onPreviousContentSpecified] method...
  @Listen('iron-signal-previous-content-specified')
  void onPreviousContentSpecified (CustomEvent event, details) {
    if ((null == details['section']) || (null == details['previousContent']) ||
        (section != details['section']) ||
        (section != (details['previousContent'] as PreviousContentMapping).section)) {
      return;
    }

    notifyPath ('hasExtraInfo', hasExtraInfo = true);
    notifyPath ('hasPreviousContent', _hasPreviousContent = true);
    notifyPath ('withPreviousContent', withPreviousContent = details['previousContent']);
  }

  /// The [onCrossListingsSpecified] method...
  @Listen('iron-signal-cross-listings-specified')
  void onCrossListingsSpecified (CustomEvent event, details) {
    if ((null == details['section']) || (null == details['crossListings'])) {
      return;
    }

    set ('withCrossListing', new CrossListing());
    set ('hasExtraInfo', true);
    notifyPath ('hasCrossListing', _hasCrossListing = true);

    var crossListings = details['crossListings'] as List<CrossListing>;

    crossListings.where (
      (CrossListing crossListing) => crossListing.sections.contains (section)
    ).forEach ((CrossListing clSet) {
      clSet.sections.forEach ((BannerSection clSection) {
        async (() {
          add ('withCrossListing.sections', clSection);
        });
      });
    });
  }

  /// The [onRemovePreviousContent] method...
  @Listen('tap')
  void onRemovePreviousContent (CustomEvent event, details) {
    if ('removePreviousContentIcon' == (Polymer.dom (event)).localTarget.id) {
      notifyPath ('withPreviousContent', withPreviousContent = null);
      notifyPath ('hasPreviousContent', _hasPreviousContent = false);

      if (null == withCrossListing) {
        notifyPath ('hasExtraInfo', hasExtraInfo = false);
      }
    }
  }

  /// The [onRemoveFromCrossListing] method...
  @Listen('tap')
  void onRemoveFromCrossListing (CustomEvent event, details) {
    if ('removeFromCrossListingIcon' == (Polymer.dom (event)).localTarget.id) {
      notifyPath ('withCrossListing', withCrossListing = null);
      notifyPath ('hasCrossListing', _hasCrossListing = false);

      if (null == withPreviousContent) {
        notifyPath ('hasExtraInfo', hasExtraInfo = false);
      }

      this.fire ('iron-signal', detail: {
        'name': 'section-removed-from-cl', 'data': {'section': section}
      });
    }
  }
}
