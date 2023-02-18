import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/backend/auth_methods.dart';
import 'package:instagram/screens/home_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/widgets/image_picker.dart';
import 'package:instagram/widgets/text_feild_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => loginScreenState();
}

class loginScreenState extends State<LoginScreen> {
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailInput.dispose();
    passwordInput.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods()
        .LoginUser(email: emailInput.text, password: passwordInput.text);
    setState(() {
      isLoading = false;
    });

    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
      // print(res);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const HomeScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              // svg image
              Image.asset(
                'assets/Instagram_logo.svg.png',
                width: 250,
                color: Colors.white,
              ),
              const SizedBox(height: 50),

              // text input email
              TextFieldInput(
                textInput: emailInput,
                keyboardinput: TextInputType.emailAddress,
                hintText: 'Enter Your Email',
              ),
              const SizedBox(height: 15),
              // number input password
              TextFieldInput(
                textInput: passwordInput,
                keyboardinput: TextInputType.visiblePassword,
                hintText: 'Enter Password',
                obscure: true,
              ),
              const SizedBox(
                height: 65,
              ),
              // login button
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : const Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: const Text('SignUp!',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      )),
      // backgroundColor: Colors.grey.shade300,
    );
  }
}
