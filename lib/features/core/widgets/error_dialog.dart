import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/features/core/resources/exceptions/app_exception.dart';

class ErrorDialog extends StatelessWidget {
  final AppException? exception;
  const ErrorDialog({super.key, this.exception});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("error_label".tr),
      content: Text(exception?.message ?? "unknown_error".tr),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("okay_label".tr),
        ),
      ],
    );
  }
}
