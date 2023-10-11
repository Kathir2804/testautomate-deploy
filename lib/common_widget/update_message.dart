import 'package:cez_tower/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpadteMessage {
  Future<void> navigateAndDisplaySelection(
      BuildContext context, bool value, String text) async {
    if (value == true) {
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 220, 252, 231),
          textColor: const Color.fromARGB(255, 21, 128, 61),
          fontSize: 16.0);
    }
  }

  Future<void> snackBarMessage(
      BuildContext context, bool value, String text) async {
    if (value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Error.error400,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          content: Row(
            children: [
              const Icon(Icons.error, color: Neutral.n0, size: 20),
              const SizedBox(width: 10),
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Neutral.n0, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.up,
          closeIconColor: Neutral.n0,
          showCloseIcon: true,
          margin: const EdgeInsets.only(bottom: 50, right: 20, left: 20),
        ));
      });
    }
  }

  Future<void> errorMessage(
      BuildContext context, bool value, String text) async {
    if (value == true) {
      OverlayEntry? overlayEntry;
      overlayEntry = OverlayEntry(builder: (context) {
        return TweenAnimationBuilder(
            curve: Curves.bounceOut,
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0, end: 55),
            builder: (context, double size, widget) {
              return Positioned(
                top: size,
                left: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Error.error400),
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error, color: Neutral.n0, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Neutral.n0,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.none,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            overlayEntry!.remove();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      });
      Overlay.of(context).insert(overlayEntry);
      await Future.delayed(const Duration(seconds: 3));
      overlayEntry.remove();
    }
  }
}
