@HtmlImport('archive_view.html')
library plato.elements.view.archive;

import 'dart:html';
import 'dart:js' show JsObject;

import 'package:web_components/web_components.dart';
import 'package:polymer/polymer.dart';

import 'package:polymer_elements/iron_ajax.dart';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/paper_submenu.dart';

import 'package:polymer_elements/neon_animation/animations/fade_in_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

import 'data_models.dart' show ArchiveItem;
import 'plato_elements_utils.dart';

/// Silence analyzer:
/// [PaperButton] - [PaperItem] - [PaperMenu] - [PaperSubmenu]
/// [FadeInAnimation] - [FadeOutAnimation]
///
/// The [ArchiveView] class...
@PolymerRegister('archive-view')
class ArchiveView extends PolymerElement {
  @Property(notify: true)
  String archiveId;

  @Property(notify: true)
  String courseTitle;

  @Property(notify: true)
  String resourceId;

  @Property(notify: true)
  String resourceTitle;

  @Property(notify: true)
  List<ArchiveItem> manifestItems;

  Map<String, String> _resourceTitles;

  IronAjax _browseAjax;

  IronAjax _resourceAjax;

  PaperDialog _resourceDialog;

  /// The [ArchiveView] factory constructor...
  factory ArchiveView() => document.createElement ('archive-view');

  /// The [ArchiveView] named constructor...
  ArchiveView.created() : super.created();

  /// The [attached] method...
  void attached() {
    set ('resourceId', 'none');

    _resourceAjax = $['preview-resource-ajax'] as IronAjax;
    _resourceDialog = $['preview-resource-dialog'] as PaperDialog;

    _initCollectiveItems();
    _initBrowseArchive();
  }

  /// The [_initCollectiveItems] method...
  void _initCollectiveItems() {
    set ('courseTitle', '');
    set ('manifestItems', new List<ArchiveItem>());
    _resourceTitles = new Map<String, String>();
  }

  /// The [_initBrowseArchive] method...
  void _initBrowseArchive() {
    _initCollectiveItems();

    _browseAjax ?? (_browseAjax = $['browse-archive-ajax'] as IronAjax)
      ..generateRequest();

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': {
      'message': 'Processing course archive information.'
    }});
  }

  /// The [onBrowseArchive] method...
  @Listen('browse-archive')
  void onBrowseArchive (CustomEvent event, details) {
    if (null != details['archiveId']) {
      set ('archiveId', details['archiveId']);

      _initBrowseArchive();
    }
  }

  /// The [onViewArchive] method...
  @Listen('response')
  void onViewArchive (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    var response = _browseAjax.lastResponse;

    if ((null != response['error']) ||
        (null == response['courseId']) || (null == response['courseTitle'])) {
      raiseError (this, 'Browsing archive error', response['error']);
      return;
    }

    set ('archiveId', response['courseId']);

    if (null != response['manifestOutline']) {
      _handleManifestOutline (
        convertToDart (response['manifestOutline'] as JsObject)
      );
    }

    set ('courseTitle', response['courseTitle']);
  }

  /// The [_handleManifestOutline] method...
  void _handleManifestOutline (Map<String, Map> manifestOutline) {
    _initCollectiveItems();

    async (() {
      manifestOutline.forEach ((String aResourceId, Map anItem) {
        if ((anItem[aResourceId] as String).contains ('divider')) {
          anItem[aResourceId] = '------------------------------------------';
        }

        var archiveItem = new ArchiveItem (aResourceId, anItem[aResourceId]);

        _resourceTitles[aResourceId] = anItem[aResourceId];

        anItem.forEach ((subResourceId, subItem) {
          if (subItem is Map) {
            subItem.forEach ((String aSubResourceId, Map aSubItemTitle) {
              archiveItem.items.add (
                new ArchiveItem (aSubResourceId, aSubItemTitle[aSubResourceId])
              );

              _resourceTitles[aSubResourceId] = aSubItemTitle[aSubResourceId];
            });
          }
        });

        add ('manifestItems', archiveItem);
      });

      this.fire ('refresh-archive-view');
    });
  }

  /// The [onPreviewResource] method...
  @Listen('tap')
  void onPreviewResource (CustomEvent event, details) {
    var resourceLink = (Polymer.dom (event)).localTarget.id as String;

    if (resourceLink.contains ('-resource-link')) {
      set ('resourceId', resourceLink.split ('-').first);

      this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': {
        'message': 'Loading the requested resource ($resourceId).'
      }});

      _resourceAjax.generateRequest();
    }
  }

  /// The [onPreviewResourceResponse] method...
  @Listen('response')
  void onPreviewResourceResponse (CustomEvent event, details) {
    this.fire ('iron-signal', detail: {'name': 'hide-progress', 'data': null});

    var response = _resourceAjax.lastResponse;

    if (null != response['error']) {
      raiseError (this, 'Browsing archive error', response['error']);
      return;
    }

    if (null == response['resource']) {
      raiseError (this,
        'Resource preview error',
        'The requested resource ($resourceId) could not be loaded for preview.'
      );

      return;
    }

    String aResourceTitle, resourceText;

    try {
      resourceText = response['resource'];
      aResourceTitle = _resourceTitles[resourceId];
    } catch (_) {}

    set ('resourceTitle', aResourceTitle ?? resourceId);

    if (('' == resourceText) || (resourceText.startsWith ('<img'))) {
      resourceText = '(This particular resource did not have a description.)';
    }

    ($['resource-preview'] as DivElement).innerHtml = resourceText;

    _resourceDialog
      ..refit()
      ..center()
      ..open();
  }
}
