import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_snap/gallery/gallery_controller.dart';
import 'package:secure_snap/models/photo_dto.dart';
import 'package:secure_snap/utils/ext/date_ext.dart';
import 'package:secure_snap/utils/frame_binding_mixin.dart';

import '../app.dart';
import '../components/no_data_view.dart';
import '../l10n/l10n.dart';
import '../utils/controller_registrar.dart';

part 'components/gallery_view.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({required this.args, super.key});

  final GalleryArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return ControllerRegistrar(
      create: (context, dependencyContext) {
        return GalleryController(
          photoRepository: dependencyContext(),
          biometricRepository: dependencyContext(),
          secureStorageRepository: dependencyContext(),
        );
      },
      listener: (controller) {
        final event = controller.removeEvent();
        if (event is PhotoReadExceptionEvent) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.photo_reading_exception)));
        } else if (event is PinAvailable) {
          context.push('/home/enter-pin');
        }
      },
      builder: (context, controller, child) {
        return _PageContent(controller: controller);
      },
    );
  }
}

class _PageContent extends StatefulWidget {
  final GalleryController controller;

  const _PageContent({required this.controller});

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> with FrameBinding {
  late final _controller = widget.controller;

  @override
  void didRenderFrame() {
    super.didRenderFrame();
    _controller.attemptAuthenticateWithBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final photos = _controller.photos;
    final authenticated = _controller.authenticated;
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.gallery)),
      body:
          photos.isEmpty && !authenticated
              ? NoDataView()
              : _GalleryView(photos: photos),
    );
  }
}
