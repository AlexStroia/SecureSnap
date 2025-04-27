import 'package:equatable/equatable.dart';

class PhotoDto with EquatableMixin {
  final String filePath;
  final DateTime createdAt;
  final int? id;

  const PhotoDto({this.id, required this.filePath, required this.createdAt});

  @override
  List<Object?> get props => [filePath, createdAt, id];

  PhotoDto copyWith({String? filePath, DateTime? createdAt, int? id}) {
    return PhotoDto(
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }
}
