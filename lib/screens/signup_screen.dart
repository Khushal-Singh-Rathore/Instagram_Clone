import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/backend/auth_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/widgets/image_picker.dart';
import 'package:instagram/widgets/text_feild_input.dart';

import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  final TextEditingController usernameInput = TextEditingController();
  final TextEditingController fullnameInput = TextEditingController();
  final TextEditingController bioInput = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailInput.dispose();
    passwordInput.dispose();
    usernameInput.dispose();
    fullnameInput.dispose();
    bioInput.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(
      ImageSource.gallery,
    );
    setState(() {
      _image = img;
    });
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().SignupUser(
        username: usernameInput.text,
        password: passwordInput.text,
        fullname: fullnameInput.text,
        email: emailInput.text,
        file: _image!,
        bio: bioInput.text);

    // if (res == 'success') {
    //   // ignore: use_build_context_synchronously
    //   setState(() {
    //     isLoading = false;
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: ((context) => const HomeScreen())));
    //   });
    // }
    if (res == "Success") {
      setState(() {
        isLoading = false;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
        showSnackBar(res, context);
      });
      // navigate to the home screen

    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // Flexible(
            //   child: Container(),
            //   flex: 1,
            // ),
            // svg image
            Image.asset(
              'assets/Instagram_logo.svg.png',
              width: 250,
              color: Colors.white,
            ),
            const SizedBox(height: 50),
            // user image

            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        backgroundImage: MemoryImage(_image!),
                        radius: 60,
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage('assets/a1.jpg'),
                        radius: 60,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // text input user name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFieldInput(
                textInput: usernameInput,
                keyboardinput: TextInputType.name,
                hintText: 'Enter Your UserName',
              ),
            ),
            const SizedBox(height: 15),
            // text input full name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFieldInput(
                textInput: fullnameInput,
                keyboardinput: TextInputType.name,
                hintText: 'Enter Your Full Name',
              ),
            ),
            const SizedBox(height: 15),
            // text input bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFieldInput(
                textInput: bioInput,
                keyboardinput: TextInputType.name,
                hintText: 'Enter Your Bio',
              ),
            ),
            const SizedBox(height: 15),
            // text input email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFieldInput(
                textInput: emailInput,
                keyboardinput: TextInputType.emailAddress,
                hintText: 'Enter Your Email',
              ),
            ),
            const SizedBox(height: 15),
            // number input password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFieldInput(
                textInput: passwordInput,
                keyboardinput: TextInputType.visiblePassword,
                hintText: 'Enter Password',
                obscure: true,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // signup button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                onTap: () async {
                  signupUser();
                },
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
                            'Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ),
                ),
              ),
            ),
            // Flexible(
            //   child: Container(),
            //   flex: 1,
            // ),
            const SizedBox(
              height: 70,
            ),
            // forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                  child: const Text('LogIn!',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            // const SizedBox(
            //   height: 15,
            // )
          ],
        ),
      )),
      // backgroundColor: Colors.grey.shade300,
    );
  }
}
