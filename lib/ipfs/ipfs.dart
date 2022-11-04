import 'package:dio/browser_imp.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ipfs_client_flutter/ipfs_client_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IPFS {
  DioForBrowser dio = DioForBrowser();
  String url = "http://127.0.0.1:49815/api/v0/files";

  Future<String?> pickAndUploadfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.single;
      FormData getFormData = _getFormData(file.bytes!);
      Response r = await upload(getFormData, file.name);

      if (r.statusCode == 200) {
        String? hash = await getHashofFile(file.name);
        if (hash != null) {
          return hash;
        }
      } else {
        if (kDebugMode) {
          // ignore: prefer_interpolation_to_compose_strings
          print("Hash function : ${r.statusMessage} ${r.statusCode}");
        }
      }
    }
    return null;
  }

  FormData _getFormData(Uint8List data) {
    return FormData.fromMap({
      'file': MultipartFile.fromBytes(data),
    });
  }

  Future<Response> upload(FormData data, String name) async {
    var params = {
      'arg': "/$name",
      'create': true,
    };
    return await dio.post(
      '$url/write?',
      data: data,
      queryParameters: params,
      onSendProgress: (received, total) {
        if (total != -1) {
          if (kDebugMode) {
            print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        }
      },
      onReceiveProgress: ((count, total) => print("$count : $total")),
    
    );
  }

  Future<String?> getHashofFile(String dir) async {
    var params = {
      'arg': '/$dir',
      'long': true,
      'U': true,
    };

    Response response = await dio.post(
      '$url/ls?',
      queryParameters: params,
      options: Options(
        responseType: ResponseType.json,
      ),
    );

    if (response.statusCode == 200) {
      Map data = response.data;
      return data["Entries"][0]["Hash"];
    } else {
      if (kDebugMode) {
        // ignore: prefer_interpolation_to_compose_strings
        print(
            "Hash function : ${response.statusMessage} ${response.statusCode}");
      }
    }
    return null;
  }

  Future<void> readFile(
      BuildContext context, String name, String address) async {
      if (!await launchUrlString(
          "https://ipfs.io/ipfs/$address?filename=$name")) {
        Alert(context: context, title: "Failed to launch url");
      }
    //   var params = {
    //     'arg': '/$name',
    //      'offset': 0,
    //     'count': 10000000,
    //   };

    //   Response response = await dio.post(
    //     '$url/read?',
    //     queryParameters: params,

    //     options: Options(
    //       responseType: ResponseType.json,
    //     ),

    //   );

    //   if (response.statusCode == 200) {
    //     print(response.data);
    //   } else {
    //     if (kDebugMode) {
    //       // ignore: prefer_interpolation_to_compose_strings
    //       print(
    //           "Hash function : ${response.statusMessage} ${response.statusCode}");
    //     }
    //   }
    //   return null;
    // }

    IpfsClient client = IpfsClient(url: "http://127.0.0.1:57444");

    client
        .read(dir: name)
        .then((value) => print(value.runtimeType))
        .onError((error, stackTrace) => print(error));
  }
}
