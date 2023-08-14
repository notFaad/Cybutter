import 'dart:io';

import 'package:cybutter/data/Type.dart';
import 'package:cybutter/data/model/content.dart';
import 'package:cybutter/data/model/file.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class CybCrawl {
  late String url;

  CybCrawl({required this.url});

  Future<List<Content>> getContent() async {
    http.Response response;
    List<Content> content = [];
    dom.Document html;
    try {
      response = await http.get(Uri.parse(url));
    } catch (e) {
      print(e.toString());
      return Future.error("Failed Retrieving Content!");
    }

    html = dom.Document.html(response.body);
    //print(response.body);
    var contents_a = html.querySelectorAll("#table > div > a");

    contents_a.forEach((element) {
      typeContent? type_content;
      switch (element.attributes['data-type']!) {
        case "video":
          {
            type_content = typeContent.VIDEO;

            break;
          }
        case "img":
          {
            type_content = typeContent.PHOTO;

            break;
          }
        case "other":
          {
            type_content = typeContent.OTHER;

            break;
          }
        default:
          {
            type_content = null;
            break;
          }
      }
      Content c = Content(
          title: element.attributes['title']!,
          type: type_content,
          source: Uri.parse(element.attributes['href'] ?? ""),
          thumbnail: Uri.parse(element.children[0].attributes['src'] ?? ""));
      content.add(c);
    });
    if (content.isEmpty) {
      return Future.error("Unrecognized Link");
    } else {
      return content;
    }
  }

  Future<List<FileDownloaded>> getFileContent() async {
    http.Response response;
    List<Content> content = [];
    List<FileDownloaded> files = [];
    dom.Document html;
    try {
      response = await http.get(Uri.parse(url));
    } catch (e) {
      print(e.toString());
      return Future.error("Failed Retrieving Content!");
    }

    html = dom.Document.html(response.body);
    //print(response.body);
    var contents_a = html.querySelectorAll("#table > div > a");

    contents_a.forEach((element) {
      typeContent? type_content;
      switch (element.attributes['data-type']!) {
        case "video":
          {
            type_content = typeContent.VIDEO;

            break;
          }
        case "img":
          {
            type_content = typeContent.PHOTO;

            break;
          }
        case "other":
          {
            type_content = typeContent.OTHER;

            break;
          }
        default:
          {
            type_content = null;
            break;
          }
      }
      Content c = Content(
          title: element.attributes['title']!,
          type: type_content,
          source: Uri.parse(element.attributes['href'] ?? ""),
          thumbnail: Uri.parse(element.children[0].attributes['src'] ?? ""));
      FileDownloaded f = FileDownloaded(con: c);
      files.add(f);
    });
    if (files.isEmpty) {
      return Future.error("Unrecognized Link");
    } else {
      return files;
    }
  }
  //JPi4AFCQ
}
