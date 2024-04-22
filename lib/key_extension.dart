import 'package:flutter/widgets.dart';

extension KeyExtension on GlobalKey {
  RenderObject? get renderObject => currentContext?.findRenderObject();

  RenderBox? get renderBox => renderObject as RenderBox?;

  Size get renderBoxSize => renderBox != null ? renderBox!.size : Size.zero;

  Offset? offsetToGlobalAncestor(GlobalKey parentKey) =>
      renderBox?.localToGlobal(Offset.zero, ancestor: parentKey.renderObject);

  Offset? get offsetToGlobal => renderBox?.localToGlobal(Offset.zero);
}
