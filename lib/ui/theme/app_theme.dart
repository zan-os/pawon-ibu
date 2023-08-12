import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: lightBackgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: lightBackgroundColor,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(
      color: blackColor,
    ),
    titleTextStyle: blackTextStyle.copyWith(
      fontSize: 17,
      fontWeight: semiBold,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: blackColor,
    unselectedLabelColor: greyColor,
    dividerColor: purpleColor,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      backgroundColor: MaterialStateProperty.all(blueColor),
      padding: const MaterialStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      ),
      textStyle: MaterialStatePropertyAll(whiteTextStyle),
    ),
  ),
);

const Color whiteColor = Color(0xffFFFFFF);
const Color blackColor = Color(0xff14193F);
const Color greyColor = Color(0xffA4A8AE);
const Color lightGreyColor = Color(0xffF1F1F9);
const Color lightBackgroundColor = Color(0xffF6F8FB);
const Color darkBackgroundColor = Color(0xff020518);
const Color blueColor = Color(0xff53C1F9);
const Color blueVariantColor = Color(0xffeef9fe);
const Color purpleColor = Color(0xff5142E6);
const Color purpleVariantColor = Color(0xffeeecfd);
const Color greenColor = Color(0xff22B07D);
const Color greenVariantColor = Color(0xffe9f7f2);
const Color redColor = Color(0xffFF2566);
const Color redVariantColor = Color(0xffffe9f0);
const Color numberBackgroundColor = Color(0xff1A1D2E);

TextStyle productNameStyle = blackTextStyle.copyWith(
  color: blackColor,
  fontWeight: FontWeight.w500,
);

TextStyle priceStyle = blackTextStyle.copyWith(
  color: blackColor,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

TextStyle descStyle = blackTextStyle.copyWith(
  color: greyColor,
  fontSize: 12,
);

TextStyle sectionTitleStyle = blackTextStyle.copyWith(
  fontSize: 15,
  fontWeight: FontWeight.w600,
);

TextStyle blackTextStyle = GoogleFonts.roboto(
  color: blackColor,
  letterSpacing: 0.13,
);

TextStyle whiteTextStyle = GoogleFonts.roboto(
  color: whiteColor,
  letterSpacing: 0.13,
);

TextStyle greyTextStyle = GoogleFonts.roboto(
  color: greyColor,
  letterSpacing: 0.13,
);

TextStyle blueTextStyle = GoogleFonts.roboto(
  color: blueColor,
  letterSpacing: 0.13,
);

TextStyle redTextStyle = GoogleFonts.roboto(
  color: redColor,
  letterSpacing: 0.13,
);

TextStyle greenTextStyle = GoogleFonts.roboto(
  color: greenColor,
  letterSpacing: 0.13,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
