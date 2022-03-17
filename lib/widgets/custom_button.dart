import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPress;
  final String label;
  final bool loading;
  final bool borderRadius;

  const CustomButton(
      {Key key,
      this.onPress,
      this.label,
      this.loading = false,
      this.borderRadius = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: loading ? null : onPress,
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: borderRadius
              ? BorderRadius.circular(6)
              : BorderRadius.circular(0),
        ),
        child: loading
            ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }
}
