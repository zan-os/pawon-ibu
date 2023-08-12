import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final bool enable;
  final Function onTap;
  const RoundedButton({
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
        onPressed: () {
          onTap();
        },
        child: Text(title),
      ),
    );
  }
}
