import 'package:flutter/material.dart';
import 'package:secure_snap/app.dart';

import '../l10n/l10n.dart';

class CameraPage extends StatefulWidget {
  final CameraArgs args;

  const CameraPage({required this.args, super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.camera)),
      body: SizedBox.shrink(),
    );
  }
}
