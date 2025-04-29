part of '../home_page.dart';

class PhotoView extends StatelessWidget {
  final String? imagePath;

  const PhotoView({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final imagePath = this.imagePath;

    if (imagePath == null || imagePath.isEmpty) {
      return SizedBox.shrink();
    }

    final file = File(imagePath);
    if (!file.existsSync()) {
      return const Icon(Icons.error);
    }

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                spreadRadius: 4,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Image.file(
            File(imagePath),
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
