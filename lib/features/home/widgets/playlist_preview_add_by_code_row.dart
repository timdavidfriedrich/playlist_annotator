import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_annotator/constants/validator.dart';
import 'package:playlist_annotator/constants/measurements.dart';
import 'package:playlist_annotator/features/core/resources/data_state.dart';
import 'package:playlist_annotator/features/core/resources/exceptions/playlist_exception.dart';
import 'package:playlist_annotator/features/core/services/data_service.dart';
import 'package:playlist_annotator/features/core/widgets/error_dialog.dart';

class PlaylistPreviewAddByCodeRow extends StatefulWidget {
  const PlaylistPreviewAddByCodeRow({super.key});

  @override
  State<PlaylistPreviewAddByCodeRow> createState() => _PlaylistPreviewAddByCodeRowState();
}

class _PlaylistPreviewAddByCodeRowState extends State<PlaylistPreviewAddByCodeRow> {
  final TextEditingController _codeController = TextEditingController();
  bool _codeIsValid = false;

  final GlobalKey _textFieldKey = GlobalKey();
  double _textFieldHeightOnInit = 0.0;

  void _addPlaylistPreviewByCode() async {
    DataService dataService = Get.find<DataService>();
    final DataState dataState = await dataService.addPlaylistPreviewByCode(_codeController.text);

    if (dataState is DataStateError) {
      Get.dialog(ErrorDialog(exception: dataState.error as JoinPlaylistException));
      return;
    }

    _codeController.clear();
    Get.back();
  }

  void _scanQrCode() {
    // TODO: Implement scanning QR code
  }

  void _checkIfCodeIsValid(String code) {
    setState(() {
      _codeIsValid = Validator.isPlaylistCodeValid(code);
    });
  }

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getHeight());
    super.initState();
  }

  void getHeight() {
    setState(() {
      _textFieldHeightOnInit = _textFieldKey.currentContext?.size?.height ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            key: _textFieldKey,
            controller: _codeController,
            onChanged: (value) => _checkIfCodeIsValid(value),
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error)),
              errorText: _codeIsValid || _codeController.text.isEmpty ? null : "add_playlist_from_code_error".tr,
              prefixIcon: Icon(Icons.content_paste_go_rounded, color: Theme.of(context).hintColor),
              labelText: "add_playlist_from_code_label".tr,
              suffixIcon: _codeIsValid
                  ? IconButton(
                      onPressed: _addPlaylistPreviewByCode,
                      icon: const Icon(Icons.check_rounded),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: Measurements.smallPadding),
        SizedBox.square(
          dimension: _textFieldHeightOnInit,
          child: MaterialButton(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceTint,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Measurements.defaultBorderRadius),
            ),
            onPressed: _scanQrCode,
            child: const Icon(Icons.qr_code_scanner_rounded),
          ),
        )
      ],
    );
  }
}
