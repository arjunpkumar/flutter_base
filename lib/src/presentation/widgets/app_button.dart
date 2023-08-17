import 'package:flutter/material.dart';
import 'package:flutter_base/src/core/app_constants.dart';
import 'package:flutter_base/src/presentation/core/theme/colors.dart';
import 'package:flutter_base/src/presentation/core/theme/text_styles.dart';

class AppButton extends StatelessWidget {
  final Widget? child;
  final String? label;
  final VoidCallback onTap;
  final Color? color;
  final Color? labelColor;
  final double elevation;
  final double height;
  final BorderRadius? borderRadius;
  final BorderSide borderSide;
  final FocusNode? focusNode;

  const AppButton({
    super.key,
    this.child,
    this.label,
    required this.onTap,
    this.color = AppColors.denimBlue,
    this.labelColor = AppColors.white,
    this.elevation = 0,
    this.height = Units.kButtonHeight,
    this.borderRadius,
    this.focusNode,
    this.borderSide = BorderSide.none,
  }) : assert(child != null || label != null);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          side: borderSide,
          borderRadius:
              borderRadius ?? BorderRadius.circular(Units.kButtonBorderRadius),
        ),
        child: InkWell(
          focusNode: focusNode,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            onTap();
          },
          child: child ??
              Center(
                child: Text(
                  (label ?? '').toUpperCase(),
                  style: TextStyles.buttonBlack(context)?.copyWith(
                    color: labelColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
        ),
      ),
    );
  }
}
