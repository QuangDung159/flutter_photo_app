import 'package:flutter/material.dart';

class CElevatedButton extends StatelessWidget {
  CElevatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.style,
  }) : super(key: key);

  final Widget child;
  final Function onPressed;
  final double? width;
  final double? height;
  final ButtonStyle? style;

  final ButtonStyle _defaultStyle = ElevatedButton.styleFrom(
    minimumSize: Size.zero,
    padding: EdgeInsets.zero,
  );

  void test() {
    print(style);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: style ?? _defaultStyle,
        // style: ButtonStyle(
        //   minimumSize: MaterialStateProperty.all<Size>(
        //     const Size(10, 10),
        //   ),
        //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(30.0),
        //       side: const BorderSide(color: Colors.red),
        //     ),
        //   ),
        // ),
        child: child,
      ),
    );
  }
}
