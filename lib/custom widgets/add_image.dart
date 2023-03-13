import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  final List<XFile> myImages;
  const AddImage({super.key, required this.myImages});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 10,
          spacing: 10,
          alignment: WrapAlignment.spaceEvenly,
          verticalDirection: VerticalDirection.up,
          children: getImages() + [makeButton()],
        ),
      ),
    );
  }

  SizedBox makeButton() {
    return SizedBox(
      height: 100,
      child: OutlinedButton(
        onPressed: () {
          showOptions(context);
        },
        style: OutlinedButton.styleFrom(
            // side: BorderSide(style: BorderStyle.values)
            ),
        child: Column(
          children: const [
            Icon(
              Icons.camera_alt,
              size: 50,
              color: Color.fromARGB(255, 0, 24, 142),
            ),
            Text(
              'Add Image',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getImages() {
    var result = <Widget>[];
    if (widget.myImages.isNotEmpty) {
      for (int i = 0; i < widget.myImages.length; i++) {
        result.add(
          Stack(
            children: [
              Image.file(
                File(widget.myImages[i].path),
                width: 100,
                height: 100,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.myImages.removeAt(i);
                    });
                  },
                ),
              )
            ],
          ),
        );
      }
    }
    return result;
  }

  Future showOptions(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a photo'),
                  onTap: () {
                    addImages(ImageSource.camera);
                  },
                ),
                const Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    addImages(ImageSource.gallery);
                  },
                ),
              ],
            ));
  }

  Future<void> addImages(ImageSource source) async {
    switch (source) {
      case ImageSource.camera:
        {
          final XFile? selectedImage =
              await _picker.pickImage(source: ImageSource.camera);
          if (selectedImage != null) {
            setState(() {
              widget.myImages.add(selectedImage);
            });
          }
        }
        break;
      case ImageSource.gallery:
        {
          final List<XFile> selectedImages = await _picker.pickMultiImage();
          if (selectedImages.isNotEmpty) {
            setState(() {
              widget.myImages.addAll(selectedImages);
            });
          }
        }
        break;
    }
  }
}
