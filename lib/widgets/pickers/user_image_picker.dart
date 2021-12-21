import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  final Function(File pickedImage) imagePickFn;

  const UserImagePicker(this.imagePickFn,{Key? key}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  late ImageSource imageSource;
  File? _pickedImageFile;
  Future<void> _pickImage() async {
    showDialog(context: context,
      builder: (context) =>
          AlertDialog(
            content: Text("Choose image source"),
            actions: [
              TextButton(
                child: Text("Camera"),
                onPressed: ()=>Navigator.pop(context, ImageSource.camera)
              ),
              TextButton(
                  child: Text("Gallery"),
                  onPressed: ()=> Navigator.pop(context, ImageSource.gallery)
              ),
            ],
          ),
    ).then((value) async {
      final picker = ImagePicker();
        final pickedImage = await picker.pickImage(source: value,
        imageQuality: 60,
        maxWidth: 150,
        );
        setState(() {
           _pickedImageFile = File(pickedImage!.path);
        });
        widget.imagePickFn(_pickedImageFile!);
    });
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      CircleAvatar(
        radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImageFile!=null? FileImage(_pickedImageFile!):null,
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          primary: Theme
              .of(context)
              .primaryColor,
        ),
        onPressed: _pickImage,
        icon: Icon(Icons.image),
        label: Text("Add Image"),
      ),
    ],
  );
}}
