import 'package:flutter/material.dart' show Color;

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    String hex = hexColor.toUpperCase().replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return int.parse(hex, radix: 16);
  }

  HexColor(String hexColor) : super(_getColorFromHex(hexColor));
}

class AppColors {
  AppColors._();

  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFF5564E);
  static const Color darkRed = Color(0xFFEB5757);
  static const Color denim = Color(0xFF1377B9);
  static const Color lightBlack = Color(0xFF454545);
  static const Color darkPink = Color(0xFFE02D57);
  static const Color softPeach = Color(0xFFF2E9E8);
  static const Color parisWhite = Color(0xFFD6E6E2);
  static const Color mandy = Color(0xFFE3486A);
  static const Color tundora = Color(0xFF464646);
  static const Color tundoraLight = Color(0xFF4A4A4A);
  static const Color tundoraDark = Color(0xFF4F4F4F);
  static const Color lightGrey = Color(0xFFE3E3E3);
  static const Color lightGrey1 = Color(0xFFF4F6F6);
  // static const Color lightGrey = Color(0xFFDEDEDE);
  static const Color dustyGrey = Color(0xFF989898);
  static const Color grey = Color(0xFF8C8C8C);
  static const Color grey2 = Color(0xFF4F4F4F);
  static const Color bayLeaf = Color(0xFF71A780);
  static const Color alto = Color(0xFFD8D8D8);
  static const Color roseBud = Color(0xFFFBBAA3);
  static const Color roseWhite = Color(0xFFF9EAE7);
  static const Color dullPink = Color(0xFFDAABB5);
  static const Color dullRose = Color(0xFFC7A3BD);
  static const Color pink = Color(0xFFAC98CD);
  static const Color chetWodeBlue = Color(0xFF8989E0);
  static const Color alphaBlack = Color(0x20000000);
  static const Color waxFlower = Color(0xFFFFBCA0);
  static const Color wedgewood = Color(0xFF458495);
  static const Color deYork = Color(0xFF7DB88D);
  static const Color blueRibbon = Color(0xFF0F72F8);
  static const Color duskBlue = Color(0xFF6873E2);
  static const Color duskBlue1 = Color(0xFF5361EE);
  static const Color aquamarine = Color(0xFF80FDF7);
  static const Color dustyGray = Color(0xFF9C9C9C);
  static const Color darkGray = Color(0xFFC4C4C4);
  static const Color dustyGray20 = Color(0x349C9C9C);
  static const Color silver = Color(0xFFB9B9B9);
  static const Color alphaWhite = Color(0xB3ffffff);
  static const Color alphaWhiteAA = Color(0xAAffffff);
  static const Color alphaWhite88 = Color(0x88ffffff);
  static const Color cornflowerBlue = Color(0xFF0B3F86);
  static const Color darkBlue = Color(0xFF333869);
  static const Color ming = Color(0xFF3F8884);
  static const Color caution = Color(0xFF629B8A);
  static const Color outerSpace = Color(0xFF222E2B);
  static const Color outerSpaceDark = Color(0xFF1C2825);
  static const Color corduroy = Color(0xFF5E726D);
  static const Color capeCod = Color(0xFF394743);
  static const Color codGray = Color(0xCB1A1919);
  static const Color mercury = Color(0xCBE7E7E7);
  static const Color mercuryAlpha = Color(0x67E7E7E7);
  static const Color mercuryLight = Color(0x4DE7E7E7);
  static const Color ivory = Color(0xFFFFFFF0);
  static const Color gallery = Color(0xFFEBEBEB);
  static const Color alabaster = Color(0xFFFAFAFA);
  static const Color whileLilac = Color(0xFFECEDF8);
  static const Color whileLilacAlpha = Color(0x66ECEDF8);
  static const Color froly = Color(0xFFF1706E);
  static const Color mountainMeadow = Color(0xFF21C979);
  static const Color green = Color(0xFF27AE60);
  static const Color greenDarker = Color(0xFF219554);

  static const Color merino = Color(0xFFFAF7F1);
  static const Color smaltBlue = Color(0xFF4E8C93);
  static const Color helpOverlay = Color(0xFF0078A4);
  static const Color palette = Color(0xFF6873E2);
  static const Color lightPalette = Color(0xff7575E0);
  static const Color dusk = Color(0xffEF90B3);

  static const Color primary = Color(0xff2B3164);
  static const Color primaryDark = Color(0xff2B3164);
  static const Color primaryLight = Color(0xff2B3164);
  static const Color accent = Color(0xff2B3164);

  static const Color bgSplash = Color(0xff2B3164);
  static const Color bgProfile = Color(0xffF3E9E8);
  static const Color bgLearning = Color(0xffF2F2F2);
  static const Color bgRead = Color(0xffa6c3a7);
  static const Color bgLearningRead = Color(0xffD0DAAB);

  static const Color bgQuizResultGreen = Color(0xff3A787E);
  static const Color bgQuizResultYellow = Color(0xffF8E3B4);
  static const Color bgQuizResultYellow1 = Color(0xffC9B668);
  static const Color bgQuizResultRed = Color(0xffF8C8C5);
  static const Color bgQuizResultRed1 = Color(0xffBA6C6D);

  static const Color bgQuizOptionGreen = Color(0xffE5F4ED);

  static const Color quizResultIconGreen = Color(0xff3A787E);
  static const Color quizResultIconYellow = Color(0xffF8B113);
  static const Color quizResultIconRed = Color(0xffF68681);

  static const Color reportChatPrimary = Color(0xFF5089E6);
  static const Color reportChatSecondary = Color(0xFF69BEF2);
  static const Color reportChatFromColor = Color(0xFFCCE1F9);
  static const Color reportListEyeColor = Color(0xFF8ABAFB);
  static const Color reportListAnonymousColor = Color(0xFF666666);
  static const Color reportListYellow = Color(0xFFF8B114);
  static const Color reportListBlue = Color(0xFF565FBB);
  static const Color reportListGrey = Color(0xFF828282);

  static const Color feedbackYellow = Color(0xFFF8B114);

  static const Color bondedStoreTotalSummary = Color(0xFFE7EBF4);
  static const Color yellow = Color(0xFFF8B114);
  static const Color blossom = Color(0xFFF0F3FB);
  static const Color blossomMauve = Color(0xFFE1E2EF);

  static const Color feedbackExpiresColor = Color(0xFFF68681);
}
