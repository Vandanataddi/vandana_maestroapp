// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as htmlParser;
// import 'package:html/dom.dart' as htmlDom;
// import 'dart:convert';
//
// class UrlData {
//   String url;
//   String thumbnailUrl;
//   String title;
//
//   UrlData({this.url = '', this.thumbnailUrl = '', this.title = ''});
//
//   static Future<UrlData> fetchThumbnailUrl(String url) async {
//     UrlData urlData = UrlData();
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         urlData.url = url;
//         final document = htmlParser.parse(response.body);
//
//         final metaTags = document.getElementsByTagName('meta');
//
//         for (var tag in metaTags) {
//           final property = tag.attributes['property'];
//
//           if (property == 'og:image') {
//             urlData.thumbnailUrl = tag.attributes['content']!;
//           }
//           else if(property == 'og:title') {
//             urlData.title = tag.attributes['content']!;
//           }
//
//           if(urlData.thumbnailUrl != "" && urlData.title != "") {
//             break;
//           }
//         }
//       } else {
//         throw 'Failed to load webpage';
//       }
//     } catch (e) {
//       print('Error fetching thumbnail: $e');
//     }
//
//     if(url.contains("tiktok.com")) {
//       String? tt = await UrlData.fetchTiktokThumbnail(url);
//       urlData.thumbnailUrl = tt != null ? tt : "";
//     }
//     return urlData;
//   }
//   static Future<String?> fetchTiktokThumbnail(String url) async {
//     final response = await http.get(Uri.parse('https://www.tiktok.com/oembed?url=$url'));
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       return jsonResponse['thumbnail_url'];
//     }
//     return "";
//   }
// }



import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:html/parser.dart' as htmlParser;

class UrlData {
  String url;
  String thumbnailUrl;
  String title;
  String base64Image;

  UrlData({
    this.url = '',
    this.thumbnailUrl = '',
    this.title = '',
    this.base64Image = '',
  });

  // Fetch Metadata & Convert Thumbnail to Base64
  static Future<UrlData> fetchThumbnailUrl(String url) async {
    UrlData urlData = UrlData(url: url);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = htmlParser.parse(response.body);
        final metaTags = document.getElementsByTagName('meta');

        for (var tag in metaTags) {
          final property = tag.attributes['property'] ?? tag.attributes['name']; // Check both property & name

          if (property == 'og:image') {
            urlData.thumbnailUrl = tag.attributes['content'] ?? "";
          } else if (property == 'og:title') {
            urlData.title = tag.attributes['content'] ?? "";
          }

          if (urlData.thumbnailUrl.isNotEmpty && urlData.title.isNotEmpty) {
            break; // Stop loop if both are found
          }
        }

        // Download & Convert Image to Base64
        if (urlData.thumbnailUrl.isNotEmpty) {
          urlData.base64Image = await downloadImageAsBase64(urlData.thumbnailUrl) ?? '';
        }

        // Store in Firebase
        if (urlData.base64Image.isNotEmpty) {
          await storeBase64InFirebase(urlData);
        }
      } else {
        print('Failed to load webpage: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching thumbnail: $e');
    }

    return urlData;
  }

  // Download Image & Convert to Base64
  static Future<String?> downloadImageAsBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        return base64Encode(bytes);
      } else {
        print('Failed to download image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }


  static Future<void> storeBase64InFirebase(UrlData urlData) async {
    try {
      final dbRef = FirebaseDatabase.instance.ref().child('stored_urls').push();
      await dbRef.set({
        "url": urlData.url,
        "title": urlData.title,
        "base64Image": urlData.base64Image,
        "timestamp": DateTime.now().toUtc().toIso8601String(),
      });
      print('Image stored successfully in Firebase');
    } catch (e) {
      print('Error storing data in Firebase: $e');
    }
  }
}
