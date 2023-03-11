import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData primaryTheme = ThemeData(
  textTheme: const TextTheme(),
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  primaryColor: primaryColor,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    color: primaryColor,
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white, size: 22),
  ),
);
const primaryColor = Color.fromARGB(255, 39, 82, 176);
final monserrat = GoogleFonts.montserrat();
final roboto = GoogleFonts.roboto();

Future showSheet(BuildContext context, Widget child,
        {bool isDismissible = true}) async =>
    await Get.bottomSheet(
      isDismissible: isDismissible,
      SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Material(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: child,
            )),
      ),
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
