import 'package:flutter/material.dart';
import 'package:online_shoes_app/controllers/login_provider.dart';
import 'package:online_shoes_app/models/auth/login_model.dart';
import 'package:online_shoes_app/views/shared/appstyle.dart';
import 'package:online_shoes_app/views/shared/custom_textfield.dart';
import 'package:online_shoes_app/views/shared/export_packages.dart';
import 'package:online_shoes_app/views/shared/reusable_text.dart';
import 'package:online_shoes_app/views/ui/auth/registration.dart';
import 'package:online_shoes_app/views/ui/mainscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool validation = false;

  void formValidation() {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      validation = true;
    } else {
      validation = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50.h,
        backgroundColor: Colors.black,
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage('assets/images/bg.jpg')
          )
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ReusableText(
                text: "Welcome",
                style: appstyle(30, Colors.white, FontWeight.w600)),

            ReusableText(
                text: "Fill in your details to login into your account",
                style: appstyle(14, Colors.white, FontWeight.normal)),

            SizedBox(
              height: 50.h,
            ),

            CustomTextField(
                keyboard: TextInputType.emailAddress,
                hintText: "Email",
                controller: email,
                validator: (email) {
                  if (email!.isEmpty && !email.contains("@")) {
                    return 'Please provide valid email';
                  } else {
                    return null;
                  }
                },
            ),

            SizedBox(
              height: 15.h,
            ),

            CustomTextField(
                hintText: "Password",
                obscureText: authNotifier.isObsecure,
                controller: password,
                suffixIcon: GestureDetector(
                  onTap: () {
                    authNotifier.isObsecure = !authNotifier.isObsecure;
                  },
                  child: authNotifier.isObsecure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                ),
              validator: (password) {
                if (password!.isEmpty && password.length < 7) {
                  return 'Password too weak';
                } else {
                  return null;
                }
              },
            ),

            SizedBox(
              height: 10.h,
            ),
            
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Registration()));
                },
                child: ReusableText(
                  text: "Register",
                  style: appstyle(14, Colors.white, FontWeight.normal),
                ),
              ),
            ),

            SizedBox(
              height: 40.h,
            ),

            GestureDetector(
              onTap: () {
                formValidation();
                if(validation) {
                  LoginModel model =
                      LoginModel(email: email.text, password: password.text);

                  authNotifier.userLogin(model).then((response) {
                    if (response == true) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                    } else {
                      debugPrint("Failed to login");
                    }
                  });
                } else {
                  debugPrint("form not validated");
                }
              },
              child: Container(
                height: 55.h,
                width: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Center(
                  child: ReusableText(
                    text: "L O G I N",
                    style: appstyle(18, Colors.black, FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
