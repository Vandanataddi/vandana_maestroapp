//using url
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class URLThumbnail extends StatefulWidget {
//   final String url;
//   final String thumbnailUrl;
//   final String title;
//
//   URLThumbnail(this.url, this.thumbnailUrl, this.title);
//
//   @override
//   _URLThumbnailState createState() => _URLThumbnailState();
// }
//
// class _URLThumbnailState extends State<URLThumbnail> {
//   String? _thumbnailUrl;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       width:100,
//     child: GestureDetector(
//       onTap: () {
//         _launchURL();
//       },
//       child: widget.thumbnailUrl != ""
//           ? Image.network(widget.thumbnailUrl, fit: BoxFit.cover, height: 100, width: 100)
//           : Image.asset('assets/images/default.jpeg', fit: BoxFit.cover, height: 100, width: 100)
//     ));
//   }
//
//   void _launchURL() async {
//     Uri uri = Uri.parse(widget.url);
//     if (await canLaunchUrl(uri)) {
//       print("sdsads");
//       LaunchMode lMode = LaunchMode.inAppBrowserView;
//       if(
//         uri.host.contains("twitter.com") ||
//         uri.host.contains("t.co") ||
//         uri.host.contains("tiktok.com") ||
//         uri.host.contains("instagram.com") ||
//         uri.host.contains("youtube.com") ||
//         uri.host.contains("youtu.be") ||
//         uri.host.contains("facebook.com")
//         ) {
//           lMode = LaunchMode.externalApplication;
//         }
//       await launchUrl(uri, mode:lMode);
//     } else {
//       throw 'Could not launch ${widget.url}';
//     }
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class URLThumbnail extends StatefulWidget {
  final String url;
  final String thumbnailBase64;
  final String title;

  URLThumbnail(this.url, this.thumbnailBase64, this.title);

  @override
  _URLThumbnailState createState() => _URLThumbnailState();
}

class _URLThumbnailState extends State<URLThumbnail> {
  Uint8List? _thumbnailBytes;

  @override
  void initState() {
    super.initState();
    _decodeBase64Image();
  }

  // void _decodeBase64Image() {
  //   try {
  //     _thumbnailBytes = base64Decode(widget.thumbnailBase64);
  //   } catch (e) {
  //     print("Error decoding base64: $e");
  //     _thumbnailBytes = null;
  //   }
  // }
  bool isBase64(String str) {
    final pattern = RegExp(r'^[A-Za-z0-9+/=]+$');
    return pattern.hasMatch(str) && str.length % 4 == 0;
  }
  void _decodeBase64Image() {
    try {
      final base64String = widget.thumbnailBase64.trim();

      // Simple check: valid base64 images often start with /9j (JPEG) or iVBORw0 (PNG)
      if (base64String.startsWith("/9j") || base64String.startsWith("iVBORw0") || isBase64(base64String)) {
        _thumbnailBytes = base64Decode(base64String);
      } else {
       // print("Not base64 image data, skipping decode");
        _thumbnailBytes = null;
      }
    } catch (e) {
      print("Error decoding base64: $e");
      _thumbnailBytes = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: GestureDetector(
        onTap: () {
          _launchURL();
        },
        child: _thumbnailBytes != null
            ? Image.memory(_thumbnailBytes!, fit: BoxFit.cover)
            : _isValidUrl(widget.thumbnailBase64)
            ? Image.network(
          widget.thumbnailBase64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // If image fails to load (like expired or 403), show default image
            return Image.asset('assets/images/default.jpeg', fit: BoxFit.cover);
          },
        )
            : Image.asset('assets/images/default.jpeg', fit: BoxFit.cover)

      ),
    );
  }

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: 100,
  //     width: 100,
  //     child: GestureDetector(
  //       onTap: () {
  //         _launchURL();
  //       },
  //       child: _thumbnailBytes != null
  //           ? Image.memory(_thumbnailBytes!, fit: BoxFit.cover, height: 100, width: 100)
  //           : Image.asset('assets/images/default.jpeg', fit: BoxFit.cover, height: 100, width: 100),
  //     ),
  //   );
  // }
  void _launchURL() async {
    Uri uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      LaunchMode lMode = LaunchMode.inAppBrowserView;
      if (
      uri.host.contains("twitter.com") ||
          uri.host.contains("t.co") ||
          uri.host.contains("tiktok.com") ||
          uri.host.contains("instagram.com") ||
          uri.host.contains("youtube.com") ||
          uri.host.contains("youtu.be") ||
          uri.host.contains("facebook.com")
      ) {
        lMode = LaunchMode.externalApplication;
      }
      await launchUrl(uri, mode: lMode);
    } else {
      throw 'Could not launch ${widget.url}';
    }
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class URLThumbnail extends StatefulWidget {
//   final String url;
//   final String thumbnail; // This can be a URL or Base64
//   final String title;
//
//   URLThumbnail(this.url, this.thumbnail, this.title);
//
//   @override
//   _URLThumbnailState createState() => _URLThumbnailState();
// }
//
// class _URLThumbnailState extends State<URLThumbnail> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 100,
//       width: 100,
//       child: GestureDetector(
//         onTap: _launchURL,
//         child: _isBase64(widget.thumbnail)
//             ? Image.memory(
//           base64Decode(widget.thumbnail),
//           fit: BoxFit.cover,
//           height: 100,
//           width: 100,
//         )
//             : Image.network(
//           widget.thumbnail,
//           fit: BoxFit.cover,
//           height: 100,
//           width: 100,
//           errorBuilder: (context, error, stackTrace) {
//             return Image.asset(
//               'assets/images/default.jpeg',
//               fit: BoxFit.cover,
//               height: 100,
//               width: 100,
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   bool _isBase64(String data) {
//     return data.startsWith('/9j'); // JPEG base64 signature
//   }
//
//   void _launchURL() async {
//     Uri uri = Uri.parse(widget.url);
//     if (await canLaunchUrl(uri)) {
//       LaunchMode lMode = LaunchMode.inAppBrowserView;
//       if (uri.host.contains("twitter.com") ||
//           uri.host.contains("t.co") ||
//           uri.host.contains("tiktok.com") ||
//           uri.host.contains("instagram.com") ||
//           uri.host.contains("youtube.com") ||
//           uri.host.contains("youtu.be") ||
//           uri.host.contains("facebook.com")) {
//         lMode = LaunchMode.externalApplication;
//       }
//       await launchUrl(uri, mode: lMode);
//     } else {
//       throw 'Could not launch ${widget.url}';
//     }
//   }
// }
