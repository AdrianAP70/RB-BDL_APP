import 'package:flutter/material.dart';
import 'package:logins_screen/Pages/PelatihanDetail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:logins_screen/Pages/Sertifikasi.dart';

class LihatSertifPIRT extends StatefulWidget {
  final String url;
  const LihatSertifPIRT({Key? key, required this.url}) : super(key: key);

  @override
  State<LihatSertifPIRT> createState() => _LihatSertifPIRTState();
}

class _LihatSertifPIRTState extends State<LihatSertifPIRT> {
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
        title: Text("Lihat Sertifikat NIB/PIRT"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => SertifikatHome()));
          },
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
