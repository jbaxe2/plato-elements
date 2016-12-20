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

import 'data_models.dart'
  show BannerSection, CrossListing, PreviousContentMapping, RequestedSection;

import 'plato_elements_utils.dart';

/// Silence analyzer:
/// [IronSignals] - [PaperCard] - [PaperIconButton] - [PaperMaterial]
///
/// The [SectionView] class establishes the view for interacting with a single
/// requested section.  The underlying model for the view is a [BannerSection]
/// instance.  This view also provides controls for adding/removing this section
/// to a cross-listing set, or specifying that the content from a previous course
/// should be copied into the underlying section.
@PolymerRegister('section-view')
class SectionView extends PolymerElement {
  @Property(notify: true)
  BannerSection section;

  RequestedSection _requestedSection;

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

  @Property(notify: true)
  bool showInvalid;

  /// The [SectionView] factory constructor.
  factory SectionView() => document.createElement ('section-view');

  /// The [SectionView] named constructor.
  SectionView.created() : super.created();

  /// The [attached] method...
  void attached() {
    set ('hasExtraInfo', false);
    set ('showInvalid', false);

    notifyPath ('hasPreviousContent', _hasPreviousContent = false);
    notifyPath ('hasCrossListing', _hasCrossListing = false);

    _requestedSection = new RequestedSection (section);
  }

  /// The [updateSection] method...
  void updateSection (BannerSection newSection) => set ('section', newSection);

  /// The [onCopyContent] method listens for the user to signify that he or she
  /// would like to copy content from a previous course into this one.
  @Listen('tap')
  void onCopyContent (CustomEvent event, details) {
    if ('copyContentIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'show-copy-content-selector', 'data': {'section': section}
      });
    }
  }

  /// The [onAddToClSet] method listens for the user to signify that he or she
  /// would like to add this course to some cross-listing set.
  @Listen('tap')
  void onAddToClSet (CustomEvent event, details) {
    if ('addToClSetIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'show-cross-listing-selector', 'data': {'sectionView': this}
      });
    }
  }

  /// The [onRemoveSection] method listens for the user to signify this section
  /// should be removed from the collection of requested sections.
  @Listen('tap')
  void onRemoveSection (CustomEvent event, details) {
    if ('removeSectionIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'section-removed', 'data': {'section': section}
      });
    }
  }

  /// The [onPreviousContentSpecified] method listens for the signal that some
  /// previous content should be copied into this section.
  @Listen('iron-signal-previous-content-specified')
  void onPreviousContentSpecified (CustomEvent event, details) {
    if ((null == details['section']) || (null == details['previousContent']) ||
        (section != details['section']) ||
        (section != (details['previousContent'] as PreviousContentMapping).section)) {
      return;
    }

    var previousContent = details['previousContent'] as PreviousContentMapping;

    if (!_requestedSection.setPreviousContent (previousContent)) {
      raiseError (this,
        'Invalid previous content action warning',
        'Cannot add previous content to a section that is cross-listed with another section having differing previous content.'
      );

      return;
    }

    set ('hasExtraInfo', true);
    set ('withPreviousContent', previousContent);
    notifyPath ('hasPreviousContent', _hasPreviousContent = true);
  }

  /// The [onCrossListingsSpecified] method listens for the signal that the
  /// cross-listing options have changed, and that this section may have been
  /// affected by those changes.  If the cross-listing options' changes includes
  /// this section, the change configurations are applied to this section.
  @Listen('iron-signal-cross-listings-specified')
  void onCrossListingsSpecified (CustomEvent event, details) {
    if ((null == details['section']) || (null == details['crossListings'])) {
      return;
    }

    set ('withCrossListing', new CrossListing());

    var crossListings = details['crossListings'] as List<CrossListing>;

    List<CrossListing> clList = crossListings.where (
      (crossListing) => crossListing.sections.contains (section)
    ).toList();

    clList.forEach ((CrossListing clSet) {
      List<BannerSection> clSections = clSet.sections;

      clSections.forEach ((BannerSection clSection) {
        async (() {
          add ('withCrossListing.sections', clSection);

          int clLength = withCrossListing.sections.length;

          if (0 < clLength) {
            set ('hasExtraInfo', true);
            notifyPath ('hasCrossListing', _hasCrossListing = true);
          }

          if (1 == clLength) {
            set ('showInvalid', true);
          } else {
            set ('showInvalid', false);

            if (0 == clLength) {
              set ('hasExtraInfo', false);
              notifyPath ('hasCrossListing', _hasCrossListing = false);
            }

            if (1 < clLength) {
              withCrossListing.isValid = true;
            }
          }
        });
      });

      if (!_requestedSection.setCrossListing (clSet)) {
        raiseError (this,
          'Invalid cross-listing action warning',
          'Unable to cross-list this section, as its previous content differs from the previous content of the other section(s).'
        );

        clSections.remove (section);

        return;
      }
    });
  }

  /// The [onRemovePreviousContent] method listens for the user to signify that
  /// this section should cancel the previous content for this section, even if
  /// previous content may not have been specified (effectively cleans the slate).
  @Listen('tap')
  void onRemovePreviousContent (CustomEvent event, details) {
    if ('removePreviousContentIcon' == (Polymer.dom (event)).localTarget.id) {
      set ('withPreviousContent', null);
      notifyPath ('hasPreviousContent', _hasPreviousContent = false);

      if (null == withCrossListing) {
        set ('hasExtraInfo', false);
      }
    }
  }

  /// The [onRemoveFromCrossListing] method listens for the user to signify that
  /// this section should be removed from whichever cross-listing set it belongs.
  @Listen('tap')
  void onRemoveFromCrossListing (CustomEvent event, details) {
    if ('removeFromCrossListingIcon' == (Polymer.dom (event)).localTarget.id) {
      this.fire ('iron-signal', detail: {
        'name': 'section-removed-from-cl',
        'data': {'crossListing': withCrossListing, 'section': section}
      });

      set ('withCrossListing', null);
      notifyPath ('hasCrossListing', _hasCrossListing = false);

      if (null == withPreviousContent) {
        set ('hasExtraInfo', false);
      }
    }
  }
}
