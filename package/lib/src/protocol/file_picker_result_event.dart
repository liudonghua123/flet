import 'dart:typed_data';

class FilePickerResultEvent {
  final String? path;
  final List<FilePickerFile>? files;

  FilePickerResultEvent({required this.path, required this.files});

  Map<String, dynamic> toJson() => <String, dynamic>{
        'path': path,
        'files': files?.map((f) => f.toJson()).toList()
      };
}

class FilePickerFile {
  final String name;
  final String? path;
  final int size;
  final Uint8List? bytes;

  FilePickerFile({required this.name, required this.path, required this.size, this.bytes});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'path': path, 'size': size, 'bytes': bytes};
}
