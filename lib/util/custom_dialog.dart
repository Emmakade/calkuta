import 'package:calkuta/util/my_color.dart';
import 'package:flutter/material.dart';

void showPromptBox(BuildContext context) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          overlayEntry!.remove(); // Dismiss the prompt box if tapped outside
        },
        child: Container(
          color: Colors
              .transparent, // Use transparent color for the overlay background
          child: Center(
            child: Dialog(
              // Replace with AwesomeDialog or custom dialog widget
              child: Container(
                color: MyColor.mytheme,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: const Text(
                  'Please select an image with a maximum size of 2 MB.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry); // Insert the overlay entry

  // Example usage: Delay the removal of the overlay entry after 3 seconds
  // Future.delayed(Duration(seconds: 3), () {
  //   overlayEntry!.remove();
  // });
}
