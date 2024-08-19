import 'package:flutter/material.dart';
import 'package:logins_screen/Pages/PelatihanDetail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:logins_screen/Pages/Pelatihan.dart';

class Youtube extends StatefulWidget {
  final String url;
  const Youtube({Key? key, required this.url}) : super(key: key);

  @override
  State<Youtube> createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lihat Sertifikat Pelatihan"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PelatihanHome()));
          },
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
