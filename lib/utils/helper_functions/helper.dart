import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHelperFunction {
  static Future<void> visitLink(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }

  static void showToast(
    BuildContext context,
    String message,
    String description,
    ToastificationType? type,
  ) {
    final textTheme = Theme.of(context).textTheme;

    toastification.dismissAll();
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      title: Text(
        message,
        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      description: Text(description, style: textTheme.bodySmall),
      alignment: Alignment.bottomRight,
      autoCloseDuration: const Duration(seconds: 5),
      icon: type == ToastificationType.success && type != null
          ? const Icon(Icons.check_circle)
          : const Icon(Icons.error),
    );
  }

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}
