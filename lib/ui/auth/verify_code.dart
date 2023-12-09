import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/posts/posts.screen.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId ;
  const VerifyCode({super.key,required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final verifyCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Verify"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
           const SizedBox(height: 50,),
            TextFormField(
              controller: verifyCodeController,
              keyboardType: TextInputType.number,
              decoration:const InputDecoration(
                  hintText: '6 digit code'
              ),
            ),
           const SizedBox(height: 80,),

            RoundButton(title: 'Verify',loading: loading, onTap: () async {
              setState(() {
                loading = true;
              });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verifyCodeController.text.toString()
                  );
                  try{
                    await auth.signInWithCredential(credential);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
                  }
                  catch(e){
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(e.toString());
                  }


            })

          ],
        ),
      ),
    );
  }
}
