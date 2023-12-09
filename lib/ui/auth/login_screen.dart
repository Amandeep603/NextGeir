import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/WeatherScreen/main_page.dart';
import 'package:flutter_firebase/ui/auth/login_with_phone.dart';
import 'package:flutter_firebase/ui/auth/signup_screen.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading= false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login()
  {
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value){
        Utils().toastMessage(value.user!.email.toString());
        Navigator.push(context, 
        MaterialPageRoute(builder: (context)=>const MainPage())
        );

        setState(() {
          loading = false;
        });

    }).onError((error, stackTrace){
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
            return true;
      },

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child:Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController ,
                        decoration: const InputDecoration(
                            hintText: 'Email',
                            suffixIcon: Icon(Icons.alternate_email)
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter email';
                          }
                          return null;
                        },
                      ),
                     const SizedBox(height: 10,),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController ,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Password',
                            suffixIcon: Icon(Icons.lock_open)
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ) ),
              const SizedBox(height: 50,),
              RoundButton(
                title: 'Login',
                loading: loading,
                onTap: (){
                  if(_formKey.currentState!.validate()){
                      login();
                  }
                },
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(onPressed: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()));
                  },
                  child:const Text("Sign Up"),)
                ],
              ),
              const SizedBox(height: 30,),
              InkWell(
                onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const LoginWithPhone()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child:const Center(
                    child: Text('Login with phone number'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
