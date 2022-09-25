import 'package:app/utils/constants.dart' as c;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomizedButton extends InkWell {
  CustomizedButton(
      {required double height,
      double? width,
      Widget? widget,
      required Color color,
      required Function() onTap,
      required String text,
      BorderRadius? borderRadius,
      Color? borderColor,
      TextStyle? textStyle})
      : super(
            onTap: widget == null ? onTap : null,
            borderRadius: borderRadius ?? c.borderRadius,
            child: Container(
              height: height,
              width: width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget ?? Text(text, style: textStyle),
                ],
              ),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: borderRadius ?? c.borderRadius,
                  border: borderColor == null
                      ? null
                      : Border.all(color: borderColor)),
            ));
}
