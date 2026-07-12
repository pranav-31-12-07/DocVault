import 'dart:io';
import 'package:doc/desc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.isDark});
  final bool isDark;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<String> saveImageToAppStorage(String originalPath) async {
    final appDir = await getApplicationDocumentsDirectory();

    final imageFolder = Directory("${appDir.path}/DocVault");

    if (!await imageFolder.exists()) {
      await imageFolder.create(recursive: true);
    }

    final extension = originalPath.split(".").last;

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}_${UniqueKey()}.$extension";

    final copiedImage = await File(originalPath).copy(
      "${imageFolder.path}/$fileName",
    );

    return copiedImage.path;
  }

  late bool isDark;
  @override
  void initState() {
    super.initState();
    isDark = widget.isDark;
    filtered_category = "All";
  }

  final box = Hive.box("documents");
  final document_name = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final List<String> images = [];
  File? selectedImage;
  String? selected_category;
  String? filtered_category;

  bool isImage = false;
  Future<void> pickImage(setDialogState) async {
    final List<XFile> pickedImages =
        await picker.pickMultiImage(imageQuality: 85);

    if (pickedImages.isNotEmpty) {
      List<String> copiedImages = [];

      for (var image in pickedImages) {
        final copiedPath = await saveImageToAppStorage(image.path);
        copiedImages.add(copiedPath);
      }

      setDialogState(() {
        isImage = true;
        images.addAll(copiedImages);
      });
    }
  }

  final List<String> categories = [
    "Identity",
    "Education",
    "Certificates",
    "Medical",
    "Travel",
    "Financial",
    "Other"
  ];
  final List<String> filters = [
    "All",
    "Identity",
    "Education",
    "Certificates",
    "Medical",
    "Travel",
    "Financial",
    "Other"
  ];

  Icon getCategoryIcon(String category) {
    switch (category) {
      case "Identity":
        return Icon(
          Icons.perm_identity,
          color: isDark ? Colors.white : Colors.black,
        );

      case "Education":
        return Icon(
          Icons.school,
          color: isDark ? Colors.white : Colors.black,
        );

      case "Certificates":
        return Icon(
          Icons.workspace_premium,
          color: isDark ? Colors.white : Colors.black,
        );

      case "Medical":
        return Icon(
          Icons.medical_services,
          color: isDark ? Colors.white : Colors.black,
        );

      case "Travel":
        return Icon(
          Icons.flight,
          color: isDark ? Colors.white : Colors.black,
        );

      case "Financial":
        return Icon(
          Icons.account_balance,
          color: isDark ? Colors.white : Colors.black,
        );

      default:
        return Icon(
          Icons.description,
          color: isDark ? Colors.white : Colors.black,
        );
    }
  }

  String searched_value = "";
  Widget build(BuildContext context) {
    final documents = box.keys.map((key) {
  final document = box.get(key);
  return {
    "key": key,
    ...Map<String, dynamic>.from(document),
  };
}).toList();
    final filteredDocuments = documents.where((document) {
      final matchesSearch = document["name"]
          .toString()
          .toLowerCase()
          .startsWith(searched_value.toLowerCase());

      final matchesCategory = filtered_category == "All" ||
          document["category"] == filtered_category;

      return matchesSearch && matchesCategory;
    }).toList();
    return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          surfaceTintColor: isDark ? Colors.black : Colors.white,
          title: Text(
            "DocVault",
            style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isDark = !isDark;
                  });
                },
                icon: isDark ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
                color: Colors.cyan)
          ],
        ),
        body:
            // Main Body
            Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  // Search bar
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          searched_value = value;
                        });
                      },
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                      cursorColor: Colors.cyan,
                      decoration: InputDecoration(
                          labelText: "Search Document",
                          labelStyle: TextStyle(color: Colors.cyan),
                          hintText: "Enter document name",
                          hintStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.cyan,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.cyan)),
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.cyan,
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),

                  // Filter
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: filtered_category,
                      dropdownColor: isDark
                          ? Color.fromARGB(255, 36, 36, 36)
                          : Colors.white,
                      decoration: InputDecoration(
                          labelText: "Filter",
                          labelStyle: TextStyle(color: Colors.cyan),
                          filled: true,
                          fillColor: isDark ? Colors.black : Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.cyan)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.cyan,
                              ))),
                      items: filters.map((filter) {
                        return DropdownMenuItem(
                          value: filter,
                          child: Text(
                            filter,
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          filtered_category = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Main List
              if (documents.isNotEmpty) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: filteredDocuments.isEmpty
                        ? Center(
                            child: Text("No Document Found!"),
                          )
                        : ListView.builder(
                            itemCount: filteredDocuments.length,
                            itemBuilder: (context, index) {
                              final document = filteredDocuments[index];
                              return InkWell(
                                onTap: () async {
                                  await Navigator.push(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return Desc(
                                        isDark: isDark,
                                        document: document,
                                        index: document["key"],
                                      );
                                    },
                                  ));
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  child: ListTile(
                                    leading: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.cyan,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child:
                                          getCategoryIcon(document["category"]),
                                    ),
                                    title: Text(
                                      document["name"],
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      document["category"],
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                )
              ] else ...[
                Expanded(
                  child: Center(
                    child: Text("No Documents"),
                  ),
                )
              ],
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor:
                  isDark ? Color.fromARGB(255, 36, 36, 36) : Colors.white,
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setDialogState) {
                    return SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              "Document Details",
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              child: Column(
                                children: [
                                  // Document Name
                                  TextFormField(
                                    controller: document_name,
                                    style: TextStyle(
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Document",
                                      labelStyle: TextStyle(color: Colors.cyan),
                                      hintText: "Enter Document Name",
                                      hintStyle: TextStyle(
                                          color: isDark
                                              ? const Color.fromARGB(
                                                  255, 172, 172, 172)
                                              : const Color.fromARGB(
                                                  255, 135, 135, 135)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      prefixIcon: const Icon(
                                        Icons.description,
                                        color: Colors.cyan,
                                      ),
                                      filled: true,
                                      fillColor: isDark
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.cyan,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.cyan,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // Category Selection
                                  DropdownButtonFormField<String>(
                                    value: selected_category,
                                    dropdownColor: isDark
                                        ? Color.fromARGB(255, 36, 36, 36)
                                        : Colors.white,
                                    decoration: InputDecoration(
                                        labelText: "Category",
                                        labelStyle:
                                            TextStyle(color: Colors.cyan),
                                        filled: true,
                                        fillColor: isDark
                                            ? Colors.grey.shade900
                                            : Colors.grey.shade100,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide:
                                                BorderSide(color: Colors.cyan)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color: Colors.cyan,
                                            ))),
                                    items: categories.map((category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selected_category = value;
                                      });
                                    },
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // Image Preview
                                  if (isImage == true) ...[
                                    images.isNotEmpty
                                        ? SizedBox(
                                            height: 120,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: images.length,
                                              itemBuilder: (context, index) {
                                                final image = images[index];
                                                return Stack(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Container(
                                                        height: 110,
                                                        width: 110,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          border: Border.all(
                                                            color: Colors
                                                                .green.shade100,
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            image: FileImage(
                                                                File(image)),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          setDialogState(
                                                            () {
                                                              images.removeAt(
                                                                  index);
                                                              if (images
                                                                  .isEmpty) {
                                                                isImage = false;
                                                              }
                                                              ;
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 26,
                                                          width: 26,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.black,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              "X",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                  // Add Image
                                  GestureDetector(
                                    onTap: () {
                                      pickImage(setDialogState);
                                    },
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.cyan),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_outlined,
                                            color: Colors.cyan,
                                            size: 35,
                                          ),
                                          Text(
                                            "Add Image",
                                            style: TextStyle(
                                                color: Colors.cyan,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.cyan),
                                      onPressed: () {
                                        box.add({
                                          "name": document_name.text,
                                          "category": selected_category,
                                          "images": List.from(
                                              images), // Good practice
                                        });

// Clear everything for next document
                                        document_name.clear();
                                        selected_category = null;
                                        images.clear();
                                        isImage = false;

                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              )),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          backgroundColor: Colors.cyan,
          child: Text(
            "+",
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
        ));
  }
}
