import 'dart:io';
import 'package:cybutter/data/Type.dart';

import 'package:cybutter/crawler/parser.dart';
import 'package:cybutter/data/model/file.dart';
import 'package:cybutter/downloader/cybdownloader.dart';
import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  // REGEX: ^(https:\/\/)?cyberdrop.me\/a{1}\/(\w)+$
  TextEditingController input = TextEditingController();
  TextEditingController folder = TextEditingController();
  late String Selected_dir;
  late List<FileDownloaded> files;
  late bool isLoaded;
  late int numberOfLinks;
  late List<String> s;
  CancelToken token = CancelToken();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Selected_dir = "";
    files = [];
    isLoaded = false;
    s = [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    token.cancel();
    input.dispose();
    folder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: TextField(
                      controller: input,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                        } else {}
                      },
                      style: const TextStyle(
                          color: Color.fromARGB(255, 224, 197, 255)),
                      decoration: InputDecoration(
                          hoverColor: Colors.white,
                          hintMaxLines: 4,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(10)),
                          hintText:
                              "Add a new line between each link Example:\nhttps://cyberdrop.me/a/9uRnD2nu\ncyberdrop.me/a/Z1HAi2fT\nusing https is optional we parse each link to https protocol",
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 224, 197, 255)))),
                ),
              ),
            )
          ],
        ),
        Container(
          height: MediaQuery.of(context).size.height / 8,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Theme.of(context).primaryColor.withAlpha(50),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: InkWell(
                      onTap: () async {
                        String? path = await getDirectoryPath();

                        if (path == null) {
                          // User canceled the picker
                          setState(() {});
                        } else {
                          setState(() {
                            Selected_dir = path;
                            folder.text = path;
                          });
                        }
                      },
                      child: TextField(
                          controller: folder,
                          enabled: false,
                          mouseCursor: SystemMouseCursors.click,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onSubmitted: (value) {
                            if (value.isEmpty) {
                              return;
                            } else {}
                          },
                          style: const TextStyle(
                              color: Color.fromARGB(255, 224, 197, 255),
                              fontSize: 14),
                          decoration: InputDecoration(
                              hoverColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  gapPadding: 5,
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: Selected_dir.isEmpty
                                  ? "Pick Directory Path:"
                                  : Selected_dir,
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 224, 197, 255))))),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 5,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                          style: const ButtonStyle(),
                          onPressed: () async {
                            if (!isLoaded) {
                              setState(() {
                                files.clear();
                              });
                              var time = DateTime.now().millisecondsSinceEpoch;

                              s = input.text.split('\n');

                              if (Selected_dir.isNotEmpty &&
                                  s.isNotEmpty &&
                                  Selected_dir.isNotEmpty &&
                                  input.text.isNotEmpty) {
                                for (int i = 0; i < s.length; i++) {
                                  if (RegExp(
                                          r'^(https:\/\/)?cyberdrop.me\/a{1}\/(\w)+$')
                                      .hasMatch(s[i].trim())) {
                                    await CybCrawl(url: s[i].trim())
                                        .getFileContent()
                                        .then((value) async {
                                      setState(() {
                                        isLoaded = true;
                                        files = value;
                                      });
                                      if (files.isNotEmpty) {
                                        for (int i = 0; i < files.length; i++) {
                                          if (token.isCancelled) {
                                            setState(() {
                                              token = CancelToken();
                                            });
                                          }

                                          await CybDownloader(
                                            url: files[i]
                                                .con!
                                                .source
                                                .toString()
                                                .trim(),
                                            savePath: Selected_dir,
                                            filename: files[i].con!.title,
                                            foldername: time.toString(),
                                            token: token,
                                            onComplete: () {
                                              setState(() {
                                                files[i].progress = "Completed";
                                              });
                                            },
                                            onError: (e) {
                                              setState(() {
                                                files[i].progress = "Error";
                                              });
                                            },
                                            onProgressChange: (value) {
                                              setState(() {
                                                files[i].progress = value;
                                              });
                                            },
                                          ).cyberdropDownloader();
                                        }

                                        setState(() {
                                          isLoaded = true;
                                          input.clear();
                                          folder.clear();
                                          Selected_dir = "";
                                        });
                                      } else {}
                                    }).onError((error, stackTrace) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Theme.of(context)
                                            .primaryColor
                                            .withAlpha(85)
                                            .withGreen(70),
                                        content: Text(
                                          "Error!: ${error} at ${s[i]}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ));
                                      setState(() {
                                        isLoaded = false;
                                        files.clear();
                                      });
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(85)
                                          .withGreen(70),
                                      content: Text(
                                        "Error!: Unknown Website ${s[i]}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ));
                                    setState(() {
                                      isLoaded = false;
                                      files = [];
                                      input.clear();
                                    });
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(85)
                                      .withGreen(70),
                                  content: Text(
                                    "Error!: Please input the cyberdrop domain and pick a directory!",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ));
                              }
                            } else {
                              // We Cancel
                              token.cancel();
                              setState(() {
                                isLoaded = false;
                                files.clear();
                              });

                              setState(() {});
                            }
                          },
                          child: !isLoaded
                              ? const Text("Download")
                              : const Text("Cancel")))),
              SizedBox(
                width: MediaQuery.of(context).size.width / 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(children: [
              Expanded(
                  child: Divider(
                thickness: 1.5,
                color: Theme.of(context).primaryColor,
              )),
            ])),
        Expanded(
            child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          color: Theme.of(context).primaryColor.withAlpha(70),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Files: [${files.length}]",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Flexible(
                  child: ListView.builder(
                itemCount: files.isEmpty ? 1 : files.length,
                itemBuilder: (context, index) {
                  return files.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Theme.of(context).primaryColor.withAlpha(60),
                          height: 75,
                          child: Row(
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                color: Colors.black.withAlpha(30),
                                child: files[index]
                                        .con!
                                        .thumbnail
                                        .toString()
                                        .isEmpty
                                    ? Image.asset(
                                        fit: BoxFit.fill,
                                        "assets/logo.svg",
                                        height: 65,
                                        width: 65,
                                      )
                                    : Image.network(
                                        files[index].con!.thumbnail.toString(),
                                        height: 85,
                                        width: 85,
                                      ),
                              ),
                              const Spacer(),
                              Container(
                                width: MediaQuery.of(context).size.width / 8,
                                child: Center(
                                  child: Text(
                                    "${files[index].con!.title}",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                (() {
                                  if (files[index].con!.type ==
                                      typeContent.VIDEO) {
                                    return "Video";
                                  } else if (files[index].con!.type ==
                                      typeContent.OTHER) {
                                    return "Other";
                                  } else {
                                    return "Photo";
                                  }
                                }()),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text("${files[index].progress}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: (() {
                                        if (files[index].progress == "Error") {
                                          return Colors.red;
                                        } else if (files[index].progress ==
                                            "Completed") {
                                          return Colors.green;
                                        } else {
                                          return Theme.of(context).primaryColor;
                                        }
                                      }()),
                                      fontWeight: FontWeight.bold)),
                              const Spacer()
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            "\nWelcome to  \n| C Y B U T T E R |.  \nInput the desired links above to be downloaded ",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                },
              ))
            ],
          ),
        ))
      ],
    ));
  }
}
