import 'package:flutter/material.dart';
import 'package:todo/helpers/colors.dart';

class CustomContainer extends StatelessWidget {
  CustomContainer({this.child, this.shadow = false, this.margin, this.padding});
  final Widget child;
  final bool shadow;
  final EdgeInsets padding;
  final EdgeInsets margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(8),
      padding: padding ?? EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        boxShadow: shadow
            ? [
                BoxShadow(
                    color: AppColors.borderColor,
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 10))
              ]
            : [],
      ),
      child: child,
    );
  }
}
