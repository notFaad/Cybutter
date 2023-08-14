import 'package:cybutter/data/Type.dart';
import 'package:cybutter/data/model/content.dart';
import 'package:flutter/material.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../crawler/parser.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  late Player player = Player();
  late final _controller = VideoController(
    player,
  );
  late bool isOriginal;
  late bool isVideo;
  late List<Content> contents;
  late String url;
  late bool isLoaded;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contents = [];
    isOriginal = true;
    isVideo = false;
    isLoaded = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withGreen(65)),
                child: const Text("Load from: https://cyberdrop.me/a/",
                    style: TextStyle(color: Colors.white, fontSize: 18))),
            SizedBox(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: TextField(
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) async {
                      if (value.isEmpty) {
                        return;
                      } else {
                        await CybCrawl(
                                url: "https://cyberdrop.me/a/${value.trim()}")
                            .getContent()
                            .then((value) {
                          player.stop();
                          setState(() {
                            isLoaded = true;
                            contents = value;
                          });
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context)
                                .primaryColor
                                .withAlpha(85)
                                .withGreen(70),
                            content: Text(
                              "Error!: ${error}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                        });

                        /*
                        Playlist p = Playlist([]);
                        contents.forEach((element) {
                          if (element.type == typeContent.VIDEO ||
                              element.type == typeContent.OTHER) {
                            p.medias.add(Media(element.source.toString()));
                          } else {

                          }
                        });
                        player.open(p);
                        print(contents.isEmpty);
                        */
                      }
                    },
                    style: const TextStyle(
                        color: Color.fromARGB(255, 224, 197, 255)),
                    decoration: InputDecoration(
                        hoverColor: Theme.of(context).primaryColor,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "Example: JPi4AFCQ",
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 224, 197, 255)))),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(children: [
              Expanded(
                  child: Divider(
                thickness: 1.5,
                color: Theme.of(context).primaryColor,
              )),
              const SizedBox(
                width: 5,
              ),
              Text("Media [Files: ${contents.length}]",
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor)),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Divider(
                thickness: 1.5,
                color: Theme.of(context).primaryColor,
              )),
            ])),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [
              if (isLoaded) ...[
                Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: 10),
                    height: MediaQuery.of(context).size.height / 1.35,
                    width: MediaQuery.of(context).size.width / 2.4,
                    color: Theme.of(context).primaryColor.withAlpha(55),
                    child: Column(
                      children: [
                        Flexible(
                            child: ListView.builder(
                          itemCount: contents.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.5),
                                child: InkWell(
                                    hoverColor: Theme.of(context)
                                        .primaryColor
                                        .withAlpha(80),
                                    onTap: () {
                                      if (contents[index].type ==
                                              typeContent.VIDEO ||
                                          contents[index].type ==
                                              typeContent.OTHER) {
                                        player.stop();
                                        setState(() {
                                          isVideo = true;
                                          isOriginal = false;
                                        });
                                        player.open(Media(
                                            contents[index].source.toString()));
                                      } else {
                                        player.stop();
                                        setState(() {
                                          isVideo = false;
                                          isOriginal = false;
                                          url =
                                              contents[index].source.toString();
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 85,
                                      color: Colors.black.withAlpha(55),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (contents[index]
                                              .thumbnail
                                              .toString()
                                              .isNotEmpty) ...[
                                            Container(
                                              width: 85,
                                              height: 85,
                                              color: Colors.black.withAlpha(30),
                                              child: Image.network(
                                                contents[index]
                                                    .thumbnail
                                                    .toString(),
                                                height: 85,
                                                width: 85,
                                              ),
                                            )
                                          ] else ...[
                                            Container(
                                              width: 85,
                                              height: 85,
                                              color: Colors.black.withAlpha(30),
                                              child: Image.asset(
                                                "assets/logo.svg",
                                                height: 65,
                                                width: 65,
                                              ),
                                            ),
                                          ],
                                          Flexible(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  contents[index].title,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              (() {
                                                if (contents[index].type ==
                                                    typeContent.VIDEO) {
                                                  return "Video";
                                                } else if (contents[index]
                                                        .type ==
                                                    typeContent.OTHER) {
                                                  return "Other";
                                                } else {
                                                  return "Photo";
                                                }
                                              }()),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )));
                          },
                        ))
                      ],
                    )),
              ],
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: isLoaded
                          ? EdgeInsets.only(bottom: 150)
                          : EdgeInsets.only(bottom: 50),
                      width: MediaQuery.of(context).size.width / 2.7,
                      height: MediaQuery.of(context).size.height / 2.7,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 0, right: 0),
                          child: AspectRatio(
                              aspectRatio: 16 / 9, child: Placeholder()))),
                  if (!isLoaded) ...[
                    Container(
                      color: Theme.of(context).primaryColor.withAlpha(90),
                      height: 50,
                      child: Center(
                        child: Text(
                            "Welcome to | C Y B U T T E R | Media Player,\ninput the path of your file above, and press enter to get started!",
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ]
                ],
              )),
            ]),
          ],
        )
      ],
    ));
  }

  Widget? Placeholder() {
    if (isOriginal && !isVideo) {
      return Image.asset(
        "assets/logo.svg",
        fit: BoxFit.contain,
      );
    } else if (isVideo && !isOriginal) {
      return Video(
        controls: MaterialDesktopVideoControls,
        controller: _controller,
      );
    } else {
      Image IMG = Image.network(url, fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            
        return Center(
          child: Text(
            "Fetching Image Failed",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        );
      }, loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      });
      ImageProvider? imageProvider = IMG.image ?? null;
      return InkWell(
          hoverColor: Theme.of(context).primaryColor.withAlpha(90),
          onTap: () {
            if (imageProvider != null) showImageViewer(context, imageProvider);
          },
          child: IMG);
    }
  }
}
