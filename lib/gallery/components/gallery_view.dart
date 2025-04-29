part of '../gallery_page.dart';

class _GalleryView extends StatelessWidget {
  final List<PhotoDto> photos;

  const _GalleryView({required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const Key('gallery_grid_view'),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return _PhotoTile(
          filePath: photo.filePath,
          createdAt: photo.createdAt.dateOnly,
        );
      },
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String filePath;
  final String createdAt;

  const _PhotoTile({required this.filePath, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      key: Key('photo_tile'),
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Positioned.fill(child: Image.file(File(filePath), fit: BoxFit.cover)),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                createdAt,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
