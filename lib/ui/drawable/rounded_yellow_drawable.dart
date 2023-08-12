import 'package:flutter/material.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';

class RoundedBlueDrawable extends StatelessWidget {
  const RoundedBlueDrawable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 130.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          color: blueColor,
        ),
      ),
    );
  }
}
