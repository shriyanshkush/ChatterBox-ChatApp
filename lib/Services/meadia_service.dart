import 'dart:io';

import 'package:image_picker/image_picker.dart';
class Mediaservice {
  final ImagePicker _imagePicker=ImagePicker();
  Future<File?> getImagefromGallery () async{
    final XFile? _file=await _imagePicker.pickImage(source:ImageSource.gallery);
    if(_file!=null) {
      return File(_file!.path);
    }
    else{
      return null;
    }

  }

}