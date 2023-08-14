import 'package:cybutter/data/Type.dart';

class Content {
  late String title;
  late typeContent? type;
  late Uri? source;
  late Uri? thumbnail;
  Content(
      {required this.title,
      required this.type,
      required this.source,
      required this.thumbnail});

  String debugString() {
    // return the variables as a string
    return "\nTitle: $title\n"
        "Source: $source\n"
        "Thumbnail: $thumbnail\n"
        "Type: ${type.toString()}\n";
  }
}
