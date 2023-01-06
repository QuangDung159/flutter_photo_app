import 'package:flutter/material.dart';
import 'package:flutter_photo_app/common/constants.dart';

class CAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  CAppBar({
    super.key,
    this.actions,
    this.leadings,
    required this.title,
    this.padding,
  });

  final List<Widget>? actions;
  final List<Widget>? leadings;
  final Widget title;
  final EdgeInsets? padding;

  void test() {
    print(actions);
  }

  List<Widget> getListWidget(List<Widget>? listWidget) {
    List<Widget> children = [];

    if (listWidget == null) {
      return [];
    }

    for (var element in listWidget) {
      children.add(element);
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    double appBarHeight = contentAppBarHeight + statusBarHeight;
    Color appBarColor = primaryBackground;

    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox(
        height: appBarHeight,
        child: Column(
          children: <Widget>[
            Container(
              height: statusBarHeight,
              color: appBarColor,
            ),
            Container(
              color: appBarColor,
              width: MediaQuery.of(context).size.width,
              height: contentAppBarHeight,
              child: Container(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          ...getListWidget(leadings),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: title,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ...getListWidget(actions),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
