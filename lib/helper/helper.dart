import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';


class Helper {
  static void copyToClipboard(String url) {
    Clipboard.setData(ClipboardData(text: url));
  }
  static Future<ShareResult> share (String url) async {
    return await Share.share(url);
  }
  static Future<String?> getClipboardData() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if(cdata != null && cdata!.text!.startsWith("https://")) {
      return cdata!.text;
    }
    return "";
  }
  static void showFlashError(BuildContext context, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Empty prompt?'),
            content: Text(
              message,
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor:
            Colors.white, // Setting overall dialog box background color
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // Remove background color
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF), // Setting button color
                    borderRadius: BorderRadius.circular(
                        5), // Optional: Adding border radius
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 92, 28, 228),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ]);
      },
    );
  }
  static void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 16, left: 16, right: 16)
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}