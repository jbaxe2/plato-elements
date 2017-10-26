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
  String resourceId;

  @Property(notify: true)
  String courseTitle;

  Map<String, Map> _manifestOutline;

  @Property(notify: true)
  List<ArchiveItem> manifestItems;

  Map<String, String> _resourceTitles;

  IronAjax _browseAjax;

  IronAjax _resourceAjax;

  PaperDialog _resourceDialog;

  @Property(notify: true)
  String resourceTitle;

  /// The [ArchiveView] factory constructor...
  factory ArchiveView() => document.createElement ('archive-view');

  /// The [ArchiveView] named constructor...
  ArchiveView.created() : super.created();

  /// The [attached] method...
  void attached() {
    _manifestOutline = new Map<String, Map>();
    _resourceTitles = new Map<String, String>();

    set ('resourceId', 'none');
    set ('manifestItems', new List<ArchiveItem>());

    this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});

    _browseAjax = $['browse-archive-ajax'] as IronAjax
      ..generateRequest();

    _resourceAjax = $['preview-resource-ajax'] as IronAjax;
    _resourceDialog = $['preview-resource-dialog'] as PaperDialog;
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
    set ('courseTitle', response['courseTitle']);

    if (null != response['manifestOutline']) {
      _manifestOutline = convertToDart (response['manifestOutline'] as JsObject);
      _handleManifestOutline();
    }
  }

  /// The [_handleManifestOutline] method...
  void _handleManifestOutline() {
    async (() {
      _manifestOutline.forEach ((String aResourceId, Map anItem) {
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

      this.fire ('iron-signal', detail: {'name': 'show-progress', 'data': null});

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
        'The requested resource was not loaded for preview.'
      );

      return;
    }

    String aResourceTitle, resourceText;

    try {
      resourceText = response['resource'];
      aResourceTitle = _resourceTitles[resourceId];
    } catch (_) {}

    set ('resourceTitle', aResourceTitle ?? resourceId);

    if ('' == resourceText) {
      resourceText = '(This particular resource did not have a description.)';
    }

    ($['resource-preview'] as DivElement).innerHtml = resourceText;

    _resourceDialog
      ..refit()
      ..center()
      ..open();
  }
}
