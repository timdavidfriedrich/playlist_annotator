import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/core/api/pocketbase/auth_service.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signInWithSpotify() async {
      AuthService authService = Get.put(AuthService());
      await authService.signIn();
    }

    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: signInWithSpotify,
          child: Text("sign_in_spotify_label".tr),
        ),
      ),
    );
  }
}
