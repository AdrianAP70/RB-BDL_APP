import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logins_screen/Screens/Login/LoginScreens.dart';

import '../../Response/UsersResponse.dart';
import '../../size_config.dart';
import '../../utils/constants.dart';
import '../custom_surfix_icon.dart';
import '../default_button_custome_color.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? noHp;
  String? alamat;
  String? password;
  bool? remember = false;

  FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  TextEditingController txtUserName = TextEditingController(),
      txtPassword = TextEditingController(),
      txtNmLengkap = TextEditingController(),
      txtAlamat = TextEditingController(),
      txtNoHp = TextEditingController(),
      txtEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUserNamaLengkapFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildUserNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildUserEmailLengkapFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAlamat(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNohPFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButtonCustomeColor(
            color: kPrimaryColor,
            text: "Register",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                LoginResponse.registerResponse({
                  "userName": txtUserName.text,
                  "password": txtPassword.text,
                  "namaLengkap": txtNmLengkap.text,
                  "email": txtEmail.text,
                  "noHp": txtNoHp.text,
                  "alamat": txtAlamat.text,
                  "role": "user"
                }, context);
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
            child: const Text(
              "Sudah punya akun ? Masuk Disini",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: txtPassword,
      onSaved: (newValue) => password = newValue,
      style: mTitleStyle,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Masukan password anda",
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildUserNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: txtUserName,
      onSaved: (newValue) => email = newValue,
      style: mTitleStyle,
      decoration: InputDecoration(
        labelText: "Username",
        hintText: "Masukan username anda",
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildUserNamaLengkapFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: txtNmLengkap,
      onSaved: (newValue) => email = newValue,
      style: mTitleStyle,
      decoration: InputDecoration(
        labelText: "Nama Lengkap",
        hintText: "Masukan nama lengkap",
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildUserEmailLengkapFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: txtEmail,
      onSaved: (newValue) => email = newValue,
      style: mTitleStyle,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Masukan email lengkap",
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildNohPFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: txtNoHp,
      onSaved: (newValue) => noHp = newValue,
      style: mTitleStyle,
      decoration: InputDecoration(
        labelText: "NoHp",
        hintText: "Masukan NoHp lengkap",
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildAlamat() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: txtAlamat,
      onSaved: (newValue) => email = newValue,
      style: mTitleStyle,
      decoration: InputDecoration(
        labelText: "Alamat",
        hintText: "Masukan alamat lengkap",
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
