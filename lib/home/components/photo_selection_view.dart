part of '../home_page.dart';

class PhotoSelectionView extends StatefulWidget {
  final ValueChanged<String>? onPhotoSaved;

  const PhotoSelectionView({required this.onPhotoSaved, super.key});

  @override
  State<PhotoSelectionView> createState() => _PhotoSelectionViewState();
}

class _PhotoSelectionViewState extends State<PhotoSelectionView> {
  String? _imagePath;
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(child: PhotoView(imagePath: _imagePath)),
            Center(
              child: AnimatedCrossFade(
                alignment: Alignment.center,
                firstChild: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      key: Key('camera_take_photo'),
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () => _takePhoto(openCamera: true),
                      label: Text(l10n.camera),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.photo_library_outlined),
                      onPressed: () => _takePhoto(openCamera: false),
                      label: Text(l10n.gallery),
                    ),
                  ],
                ),
                secondChild: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextButton.icon(
                        key: Key('save_photo'),
                        icon: const Icon(Icons.check),
                        onPressed: _onPhotoSavePressed,
                        label: Text(
                          l10n.save_photo,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      child: TextButton.icon(
                        icon: const Icon(Icons.close),
                        onPressed: _reject,
                        label: Text(l10n.reject, textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                crossFadeState: _crossFadeState,
                duration: Duration(milliseconds: 300),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPhotoSavePressed() async {
    final l10n = L10n.of(context);
    final navigator = Navigator.of(context);
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.are_you_sure_save_photo, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: TextButton.icon(
                      key: Key('save_photo_yes'),
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        final imagePath = _imagePath;
                        if (imagePath != null) {
                          Navigator.of(context).pop(true);
                          widget.onPhotoSaved?.call(imagePath);
                        }
                      },
                      label: Text(l10n.yes),
                    ),
                  ),
                  Flexible(
                    child: TextButton.icon(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(false),
                      label: Text(l10n.no),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    navigator.pop();
  }

  void _reject() {
    setState(() {
      _crossFadeState = CrossFadeState.showFirst;
      _imagePath = null;
    });
  }

  Future<void> _takePhoto({required bool openCamera}) async {
    final pickedImage = await context.read<PhotoPickerService>().pickImage(
      openCamera,
    );

    if (pickedImage != null) {
      setState(() {
        _crossFadeState = CrossFadeState.showSecond;
        _imagePath = pickedImage.path;
      });
    }
  }
}
