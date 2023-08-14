import 'dart:io';

import 'package:dio/dio.dart';

class CybDownloader {
  late void Function(String e) onError;
  late void Function() onComplete;
  late void Function(String value) onProgressChange;
  late String url;
  late String savePath;
  late CancelToken token;
  late String foldername;
  late String filename;

  CybDownloader(
      {required this.url,
      required this.savePath,
      required this.filename,
      required this.foldername,
      required this.token,
      required this.onComplete,
      required this.onError,
      required this.onProgressChange});

  Future cyberdropDownloader() async {
    try {
      Dio dio = Dio();

      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        cancelToken: token,
        options: Options(
            persistentConnection: true,
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      File file = File("$savePath/$foldername/$filename");
      await file.create(recursive: true);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      onComplete();
    } catch (e) {
      onError(e.toString());
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      onProgressChange((received / total * 100).toStringAsFixed(0) + " %");
    } else {}
  }
}
