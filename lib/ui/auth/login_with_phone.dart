import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/verify_code.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {

  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
                const SizedBox(height: 50,),
            TextFormField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                decoration:const InputDecoration(
                  hintText: '+1 234 3455 234'
                ),
            ),
            const SizedBox(height: 80,),
            
            RoundButton(title: 'Login',loading: loading, onTap: () {
              setState(() {
                loading =true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                        setState(() {
                          loading = false;
                        });
                  },
                  verificationFailed: (e){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                  },
                  codeSent: (String verificationId, int? token){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> VerifyCode(verificationId:verificationId ,)));
                  setState(() {
                    loading = false;
                  });
                  },
                  codeAutoRetrievalTimeout: (e){
                    Utils().toastMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  });

            })

          ],
        ),
      ),
    );
  }
}
