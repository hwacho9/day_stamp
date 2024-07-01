import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_stamp/home_page.dart';
import 'package:day_stamp/screens/components/input_box.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      EmailInput(
                        controller: _emailController,
                      ),
                      const SizedBox(height: 15),
                      PasswordInput(
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 10),
                      signUpButton(),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox signUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.orange,
        ),
        onPressed: () async {
          if (_key.currentState!.validate()) {
            try {
              final credential = await _firebase.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              );

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(
                    credential.user!.uid,
                  )
                  .set({
                'email': _emailController.text,
                'uid': credential.user!.uid,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("サインアップに成功しました"),
                ),
              );
            } on FirebaseAuthException catch (error) {
              if (error.code == 'メールアドレスがすでに使用されています') {
                //
              }
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.message ?? "認証に失敗しました"),
                ),
              );
            }
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        child: const Text("サインアップ"),
      ),
    );
  }
}
