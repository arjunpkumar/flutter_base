import 'package:flutter/material.dart';

class TextStyles {
  TextStyles._();

  static const _kRoboto = "Roboto";

  static TextStyle? h1ExtraLight(BuildContext context) =>
      Theme.of(context).textTheme.headline3?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 50,
            fontWeight: FontWeight.w200,
            letterSpacing: -1.5,
          );

  static TextStyle? h3Light(BuildContext context) =>
      Theme.of(context).textTheme.headline3?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 36,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.84,
          );

  static TextStyle? h3Dark(BuildContext context) =>
      Theme.of(context).textTheme.headline2?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 28,
            fontWeight: FontWeight.w400,
            letterSpacing: -1.5,
          );

  static TextStyle? h2ExtraLight(BuildContext context) =>
      Theme.of(context).textTheme.headline4?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 24,
            fontWeight: FontWeight.w200,
            letterSpacing: -0.72,
            height: 1.25,
          );

  static TextStyle? h2Light(BuildContext context, {double fontDelta = 0}) =>
      Theme.of(context).textTheme.headline4?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 24.0 + fontDelta,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.72,
            height: 1.25,
          );

  static TextStyle? h2Bold(BuildContext context, {double fontDelta = 0}) =>
      Theme.of(context).textTheme.headline4?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 24.0 + fontDelta,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.72,
            height: 1.25,
          );

  static TextStyle? titleSemiBold(
    BuildContext context, {
    double fontDelta = 0,
  }) =>
      Theme.of(context).textTheme.headline6?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 20.0 + fontDelta,
            fontWeight: FontWeight.w600,
            height: 1.1,
          );

  static TextStyle? title2Bold(BuildContext context) =>
      Theme.of(context).textTheme.headline6?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          );

  static TextStyle? title2Medium(BuildContext context,
          {double fontDelta = 0}) =>
      Theme.of(context).textTheme.headline6?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 16.0 + fontDelta,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.25,
          );

  static TextStyle? title3Bold(BuildContext context) =>
      Theme.of(context).textTheme.headline6?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.23,
            height: 1.07,
          );

  static TextStyle? buttonBlack(BuildContext context) =>
      Theme.of(context).textTheme.button?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.23,
          );

  static TextStyle? buttonSemibold(BuildContext context) =>
      Theme.of(context).textTheme.button?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.23,
          );

  static TextStyle? body1Bold(BuildContext context) =>
      Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            height: 1.23,
          );

  static TextStyle? body2Regular(BuildContext context) =>
      Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.2,
            height: 1.23,
          );

  static TextStyle? body1BoldMarkdown(
    BuildContext context, {
    double fontDelta = 0,
  }) =>
      Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 16.0 + fontDelta,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            height: 1.5,
          );

  static TextStyle? body1Regular(BuildContext context) =>
      Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 13,
            letterSpacing: -0.2,
            height: 1.23,
          );

  static TextStyle? body1RegularMarkdown(
    BuildContext context, {
    double fontDelta = 0,
  }) =>
      Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 16.0 + fontDelta,
            letterSpacing: -0.2,
            height: 1.23,
          );

  static TextStyle? captionBold(BuildContext context) =>
      Theme.of(context).textTheme.caption?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          );

  static TextStyle? captionRegular(BuildContext context) =>
      Theme.of(context).textTheme.caption?.copyWith(
            fontFamily: _kRoboto,
            fontSize: 12,
          );
}
