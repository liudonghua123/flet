import 'package:flutter/material.dart';

import '../flet_app_services.dart';
import '../models/control.dart';
import '../utils/edge_insets.dart';
import '../utils/launch_url.dart';
import 'create_control.dart';

class ListTileControl extends StatelessWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;

  const ListTileControl(
      {Key? key,
      this.parent,
      required this.control,
      required this.children,
      required this.parentDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("ListTile build: ${control.id}");

    final server = FletAppServices.of(context).server;

    var leadingCtrls =
        children.where((c) => c.name == "leading" && c.isVisible);
    var titleCtrls = children.where((c) => c.name == "title" && c.isVisible);
    var subtitleCtrls =
        children.where((c) => c.name == "subtitle" && c.isVisible);
    var trailingCtrls =
        children.where((c) => c.name == "trailing" && c.isVisible);

    bool selected = control.attrBool("selected", false)!;
    bool dense = control.attrBool("dense", false)!;
    bool isThreeLine = control.attrBool("isThreeLine", false)!;
    bool autofocus = control.attrBool("autofocus", false)!;
    bool onclick = control.attrBool("onclick", false)!;
    String url = control.attrString("url", "")!;
    String? urlTarget = control.attrString("urlTarget");
    bool disabled = control.isDisabled || parentDisabled;

    Function()? onPressed = (onclick || url != "") && !disabled
        ? () {
            debugPrint("ListTile ${control.id} clicked!");
            if (url != "") {
              openWebBrowser(url, webWindowName: urlTarget);
            }
            if (onclick) {
              server.sendPageEvent(
                  eventTarget: control.id, eventName: "click", eventData: "");
            }
          }
        : null;

    Function()? onLongPress = disabled
        ? null
        : () {
            debugPrint("Button ${control.id} clicked!");
            server.sendPageEvent(
                eventTarget: control.id,
                eventName: "long_press",
                eventData: "");
          };

    ListTile tile = ListTile(
      autofocus: autofocus,
      contentPadding: parseEdgeInsets(control, "contentPadding"),
      isThreeLine: isThreeLine,
      selected: selected,
      dense: dense,
      onTap: onPressed,
      onLongPress: onLongPress,
      enabled: !disabled,
      leading: leadingCtrls.isNotEmpty
          ? createControl(control, leadingCtrls.first.id, disabled)
          : null,
      title: titleCtrls.isNotEmpty
          ? createControl(control, titleCtrls.first.id, disabled)
          : null,
      subtitle: subtitleCtrls.isNotEmpty
          ? createControl(control, subtitleCtrls.first.id, disabled)
          : null,
      trailing: trailingCtrls.isNotEmpty
          ? createControl(control, trailingCtrls.first.id, disabled)
          : null,
    );

    return constrainedControl(context, tile, parent, control);
  }
}
