import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar extends StatefulWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
    required this.enlaceImagen,
  });

  final String? imageUrl;
  final void Function(String) onUpload;
  final String enlaceImagen;

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  bool _isLoading = false;
  final supabase = Supabase.instance.client;
  late String enlaceImagen;

  @override
  void initState() {
    super.initState();
    enlaceImagen = widget
        .enlaceImagen; // Se inicializa 'enlace' con 'enlaceImagen' del widget
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
          Container(
            width: 150,
            height: 150,
            color: Colors.grey,
            child: const Center(
              child: Text('No Image'),
            ),
          )
        else
          Image.network(
            widget.imageUrl!,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ElevatedButton(
          onPressed: _isLoading ? null : _upload,
          child: const Text('Cargar Imagen'),
        ),
      ],
    );
  }

  Future<void> _upload() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (imageFile == null) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile;
      final fileName = fileExt.name;
      final filePath = fileName;
      final String fullPath = await supabase.storage
          .from('avatars')
          .uploadBinary(enlaceImagen, bytes);
      // await supabase.storage.from('avatars').uploadBinary(
      //       fileName,
      //       bytes,
      //       fileOptions: FileOptions(contentType: imageFile.mimeType),
      //     );
      print(enlaceImagen);
      print('subido');
      print(filePath);
      print(fileExt);
      print(fileName);
      final imageUrlResponse = await supabase.storage
          .from('avatars')
          .createSignedUrl(enlaceImagen, 60 * 60 * 24 * 365 * 10);
      widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unexpected error occurred'),
          backgroundColor: Colors.red,
        ));
      }
    }

    setState(() => _isLoading = false);
  }
}
