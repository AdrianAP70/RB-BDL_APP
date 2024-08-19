import 'package:flutter/material.dart';
import 'package:logins_screen/Components/title_text.dart';

class HeadersForHome extends StatefulWidget {
  final String menu;
  HeadersForHome(this.menu, {Key? key}) : super(key: key);
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<HeadersForHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        TitleText(
          text: widget.menu,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          width: 10,
        ),
        Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 40,
        ),
      ],
    );
  }
}
