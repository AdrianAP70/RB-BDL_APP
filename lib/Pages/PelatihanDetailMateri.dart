import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:logins_screen/Pages/DashboardUser.dart';
import 'package:logins_screen/Pages/Pelatihan.dart';
import '../../../../size_config.dart';

class DetailMateri extends StatefulWidget {
  static String routeName = "/detail_materi";

  @override
  State<DetailMateri> createState() => _DetailMateriState();
}

class _DetailMateriState extends State<DetailMateri> {
  late YoutubePlayerController _controller;
  late String url;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var uriYoutobe = ModalRoute.of(context)!.settings.arguments as Map;

    print("INI URL");
    print(uriYoutobe);
    _controller = YoutubePlayerController(
      initialVideoId: _getYoutubeVideoId(uriYoutobe["linkYoutube"]),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getYoutubeVideoId(String url) {
    final Uri uri = Uri.parse(url);
    if (uri.host == 'youtu.be') {
      return uri.pathSegments.first;
    } else if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var dataPelatihan = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
        appBar: AppBar(
          title: Text(dataPelatihan["namaPelatihan"]),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: false,
                    onReady: () {
                      print('Player is ready.');
                    },
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      dataPelatihan["judulMateri"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        dataPelatihan["isiMateri"],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PelatihanHome()));
                          },
                          child: Text(
                            "Selesai",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
