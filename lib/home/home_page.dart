import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_snap/utils/controller_registrar.dart';

import '../app.dart';
import '../l10n/l10n.dart';
import 'home_controller.dart';

part 'components/photo_view.dart';

part 'components/photo_selection_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.args, super.key});

  final HomeArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return ControllerRegistrar(
      create: (context, dependencyContext) {
        return HomeController(
          photoRepository: dependencyContext(),
          biometricRepository: dependencyContext(),
          secureStorageRepository: dependencyContext(),
        );
      },
      listener: (controller) {
        final event = controller.removeEvent();
        switch (event) {
          case PhotoSavingException _:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.photo_saving_exception)),
            );
            break;
          case PhotoSavedEvent _:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.photo_saved)));
            break;
          case BiometricAuthenticationException _:
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.biometric_exception)));
            break;

          case BiometricNotAvailableException _:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.biometric_not_available)),
            );
            context.push('/home/set-pin');
            break;

          case PinAvailable _:
            context.push('/home/enter-pin');
            break;

          default:
            break;
        }
      },
      builder: (context, controller, child) {
        return _PageContent(controller: controller);
      },
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.secure_snap)),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (controller.isLoading) LinearProgressIndicator(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      key: const Key('camera_button'),
                      onPressed: () => _showTakePhotoModal(context),
                      label: Text(l10n.take_photo),
                      icon: const Icon(Icons.camera_alt_outlined),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      key: const Key('gallery_button'),
                      onPressed: () {
                        context.push('/home/gallery');
                      },
                      label: Text(l10n.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTakePhotoModal(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        builder:
            (context) => PhotoSelectionView(onPhotoSaved: controller.savePhoto),
      );
}
