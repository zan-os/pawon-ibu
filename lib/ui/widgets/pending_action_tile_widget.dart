import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PendingActionTileWidget extends StatelessWidget {
  final String? title;
  final String? count;
  const PendingActionTileWidget({
    super.key,
    this.title = '',
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title ?? '', style: const TextStyle(color: greyColor)),
        Row(
          children: [
            Text(
              count ?? '0',
              style: const TextStyle(color: greyColor),
            ),
            const SizedBox(width: 16.0),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: greyColor,
              size: 13.0,
            ),
          ],
        )
      ],
    );
  }
}
