import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:todo/helpers/colors.dart';

class CustomAppbar extends StatelessWidget {
  CustomAppbar(
    this.title, {
    this.actions,
    this.titleWidget,
    this.goBack = false,
  });
  final bool goBack;
  final Widget titleWidget;
  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 44,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.25,
            child: goBack
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Mdi.arrowLeft),
                    ),
                  )
                : SizedBox(),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: titleWidget ??
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline6
                        .copyWith(color: AppColors.highlightColor),
                  ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.23,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions != null ? actions : [],
            ),
          ),
        ],
      ),
    );
  }
}
