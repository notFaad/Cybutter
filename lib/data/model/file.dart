import 'package:cybutter/data/model/content.dart';

class FileDownloaded {
  Content? con;
  bool? isComplete;
  bool? isError;
  String? progress;

  FileDownloaded(
      {required this.con,
      this.isComplete = false,
      this.progress = "0 %",
      this.isError = false});
}
