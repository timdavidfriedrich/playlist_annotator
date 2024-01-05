import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/services/auth_service.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signInWithSpotify() async {
      AuthService authService = Get.find();
      await authService.signIn();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Text(
              "app_title".tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Measurements.normalPadding),
            Text(
              "test_version_label".tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).hintColor),
            ),
            const Spacer(flex: 4),
            FilledButton(
              onPressed: signInWithSpotify,
              child: Text("sign_in_spotify_label".tr),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
