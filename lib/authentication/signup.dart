import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getx_mysql_tutorial/api/api.dart';
import 'package:getx_mysql_tutorial/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var formKey = GlobalKey<FormState>();

  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  checkUserEmail() async {
    //http post method
    //1. 이메일 존재 여부 확인
    //2. 존재 시 Email is already in use. Please try another email => flutter Toast
    //3. 없으면 saveInfo 호출
    try {
      final userEmail = emailController.text.trim();
      final uri = Uri.parse(API.validateEmail);
      final body = jsonEncode(<String, String>{'user_email': userEmail});
      final response =
          await http.post(uri, body: body, headers: requestHeaders);
      if (response.statusCode == 200) {
        dynamic? request = response.request;

        print('request ${request!.toString()}');
        print('request.headers ${response.request!.headers}');
        print('response.body ${response.body}');

        var data = jsonDecode(response.body);
        if (data['isExistEmail']) {
          Fluttertoast.showToast(
              msg: 'Email is already in use. Please try another email');
        } else {
          saveInfo();
        }
      }
    } catch (e) {
      print('url:${API.validateEmail}');
      print('error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveInfo() async {
    //1. userModel 생성
    //2. signup 호출
    //3. 성공 시 "Signup seccessflully" Toast
    //   form 필드 clear
    //4. 오류 시  "Error occurred. Please try again" Toast

    User userModel = User(
        userId: 5,
        userName: userNameController.text,
        userEmail: emailController.text,
        userPassword: passwordController.text);
    print('toJson:${userModel.toJson()}');

    try {
      final response = await http.post(Uri.parse(API.signup),
          body: jsonEncode(userModel.toJson()), headers: requestHeaders);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          userNameController.clear();
          emailController.clear();
          passwordController.clear();
          Fluttertoast.showToast(msg: 'Signup successfully');
        } else {
          Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        }
      }
    } catch (e) {
      print('url:${API.signup}');
      print('error: $e');
      Fluttertoast.showToast(msg: e.toString());
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.card_travel_outlined,
                    color: Colors.deepPurple,
                    size: 100,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.bebasNeue(fontSize: 36.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Thank you for join us',
                      style: GoogleFonts.bebasNeue(fontSize: 28)),
                  SizedBox(
                    height: 50,
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextFormField(
                                  controller: userNameController,
                                  validator: (val) => val == ""
                                      ? "Please enter username "
                                      : null,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'User'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextFormField(
                                  controller: emailController,
                                  validator: (val) =>
                                      val == "" ? "Please enter email" : null,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextFormField(
                                  controller: passwordController,
                                  validator: (val) => val == ""
                                      ? "Please enter password"
                                      : null,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Password'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        checkUserEmail();
                      }
                    },
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already registered?'),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          ' Go back Login page!',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
