import 'package:url_launcher/url_launcher.dart';

class MyHelperFunction {
  static Future<void> visitLink(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }
}
