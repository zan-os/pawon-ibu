import 'package:flutter/material.dart';

import '../../../../ui/theme/app_theme.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      alignment: const AlignmentDirectional(-1, 0),
      child: const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
        child: Text(
          'Pawon Ibu App',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
