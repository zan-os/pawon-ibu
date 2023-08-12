import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class DividerWidget extends StatelessWidget {
  final double padding;
  const DividerWidget({
    Key? key,
    this.padding = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: const Divider(color: lightBackgroundColor, thickness: 2),
    );
  }
}
