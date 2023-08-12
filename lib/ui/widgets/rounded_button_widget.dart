import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pawon_ibu_app/ui/theme/app_theme.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String title;
  final bool enable;
  final Function onTap;
  const RoundedButtonWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: (enable) ? blueColor : CupertinoColors.systemGrey4,
        ),
        onPressed: () {
          onTap();
        },
        child: Text(
          title,
          style: whiteTextStyle.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
