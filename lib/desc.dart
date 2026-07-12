import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class Desc extends StatefulWidget {
  const Desc({
    super.key,
    required this.isDark,
    required this.document,
    required this.index,
  });

  final bool isDark;
  final Map<dynamic, dynamic> document;
  final int index;
  @override
  State<Desc> createState() => _DescState();
}

class _DescState extends State<Desc> {
  late List<String> images;
  late bool isDark;
  int currentImg = 0;
  late int index;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    isDark = widget.isDark;
    index = widget.index;
    images = List<String>.from(widget.document["images"]);
  }

  @override
  final box = Hive.box("documents");
  Widget build(BuildContext context) {
    final name = widget.document["name"].toString();
    final category = widget.document["category"].toString();
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: isDark ? Colors.black : Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "DocVault",
          style: const TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.cyan,
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1d1d1d) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .42,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 5,
                        child: PageView.builder(
                          controller: controller,
                          itemCount: images.length,
                          onPageChanged: (value) {
                            setState(() {
                              currentImg = value;
                            });
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                final previewController = PageController(
                                  initialPage: index,
                                );
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.black,
                                      insetPadding: const EdgeInsets.all(0),
                                      child: Stack(
                                        children: [
                                          PageView.builder(
                                            controller: previewController,
                                            itemCount: images.length,
                                            onPageChanged: (value) {
                                              setState(() {
                                                currentImg = value;
                                              });
                                            },
                                            itemBuilder: (context, index) {
                                              return Image.file(
                                                File(images[index]),
                                                fit: BoxFit.contain,
                                              );
                                            },
                                          ),
                                          Positioned(
                                            top: 40,
                                            right: 20,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Image.file(
                                File(images[index]),
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (images.length > 1) ...[
                  const SizedBox(height: 14),
                  Text(
                    "${currentImg + 1}/${images.length}",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              name,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "Category",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              category,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 145,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: isDark
                                          ? const Color(0xff1d1d1d)
                                          : Colors.grey.shade100,
                                      title: Text(
                                        "Download ${name} as",
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "Image",
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          onPressed: () async {
                                            final permission = await Permission
                                                .photos
                                                .request();

                                            if (!permission.isGranted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text("Permission Denied"),
                                                ),
                                              );
                                              return;
                                            }
                                            if (images.length == 1) {
                                              final Uint8List bytes =
                                                  await File(images[currentImg])
                                                      .readAsBytes();

                                              final result =
                                                  await SaverGallery.saveImage(
                                                bytes,
                                                fileName:
                                                    "${name}_${currentImg + 1}.jpg",
                                                skipIfExists: false,
                                              );
                                              print(result);
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  "Image saved to gallery",
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ));
                                              print("Image saved to gallery");
                                              print(images[currentImg]);
                                              print(File(images[currentImg])
                                                  .existsSync());
                                            } else {
                                              for (int i = 0;
                                                  i < images.length;
                                                  i++) {
                                                final Uint8List bytes =
                                                    await File(images[i])
                                                        .readAsBytes();

                                                await SaverGallery.saveImage(
                                                  bytes,
                                                  fileName:
                                                      "${name}_${i + 1}.jpg",
                                                  skipIfExists: false,
                                                );
                                              }
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  "Image saved to gallery",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ));
                                              print("Image saved to gallery");
                                            }
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "PDF",
                                            style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          onPressed: () async {
                                            final pdf = pw.Document();
                                            String fileName =
                                                "${name.toLowerCase().replaceAll(" ", "_").replaceAll(RegExp(r'[^a-z0-9_]'), "")}.pdf";
                                            if (images.length == 1) {
                                              final bytes =
                                                  File(images[currentImg])
                                                      .readAsBytesSync();
                                              final image =
                                                  pw.MemoryImage(bytes);
                                              pdf.addPage(pw.Page(
                                                build: (context) {
                                                  return pw.Center(
                                                      child: pw.Image(
                                                    image,
                                                    fit: pw.BoxFit.contain,
                                                  ));
                                                },
                                              ));

                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  "PDF saved successfully",
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ));
                                              print("PDF saved to gallery");
                                              print(images[currentImg]);
                                              print(File(images[currentImg])
                                                  .existsSync());
                                            } else {
                                              for (String path in images) {
                                                final bytes = File(path)
                                                    .readAsBytesSync();
                                                final image =
                                                    pw.MemoryImage(bytes);
                                                pdf.addPage(pw.Page(
                                                  build: (context) {
                                                    return pw.Center(
                                                        child: pw.Image(
                                                      image,
                                                      fit: pw.BoxFit.contain,
                                                    ));
                                                  },
                                                ));
                                              }

                                              Navigator.pop(context);
                                            }
                                            final pdf_bytes = await pdf.save();
                                            final params = SaveFileDialogParams(
                                                data: pdf_bytes,
                                                fileName: fileName);
                                            final file_path =
                                                await FlutterFileDialog
                                                    .saveFile(params: params);
                                            if (file_path != null) {
                                              ScaffoldMessenger.maybeOf(context)
                                                  ?.showSnackBar(SnackBar(
                                                      content: Text(
                                                "PDF saved to $file_path",
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )));
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.download,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              label: Text(
                                "Download",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          SizedBox(
                            width: 145,
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: isDark
                                          ? const Color(0xff1d1d1d)
                                          : Colors.grey.shade100,
                                      title: Text(
                                        "Are you sure you want to delete ${name}?",
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 20),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("No",
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          onPressed: () async {
for (String path in images) {
  try {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    debugPrint("Failed to delete $path: $e");
  }
}

await box.delete(index);

Navigator.pop(context);
Navigator.pop(context);
},
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              label: Text(
                                "Delete",
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
