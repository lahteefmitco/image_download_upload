import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_download_upload/main.dart';
import 'package:path_provider/path_provider.dart';

class ImageDownloadAndUpladRepository {
  final Dio dio;

  ImageDownloadAndUpladRepository({required this.dio}) {
    // Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          log("request send");
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // Do something with response data.
          // If you want to reject the request with a error message,
          // you can reject a `DioException` object using `handler.reject(dioError)`.
          log("response");
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // Do something with response error.
          // If you want to resolve the request with some custom data,
          // you can resolve a `Response` object using `handler.resolve(response)`.
          log("Error");
          return handler.next(error);
        },
      ),
    );
  }

  // Fetch welcome message to display in splash screen
  Future<String> getWelcomeMessage() async {
    try {
      final response = await dio.get("/");
      if (response.statusCode == 200) {
        final String welcomeMessage = response.data;
        return welcomeMessage;
      } else {
        throw Exception("Unknown Exception");
      }
    } on DioException catch (e) {
      log(e.toString(), name: "uploadimage");
      rethrow;
    } catch (e) {
      log(e.toString(), name: "uploadImage");
      rethrow;
    }
  }

  Future<String> uploadAnImage(File file) async {
    try {
      // uploading image as form data
      final formData =
          FormData.fromMap({"image": await MultipartFile.fromFile(file.path)});
      final response = await dio.post("/upload", data: formData);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // get image address from response
        return data["image"];
      } else {
        throw Exception("unknown Exception");
      }
    } on DioException catch (e) {
      log(e.toString(), name: "uploadimage");
      rethrow;
    } catch (e) {
      log(e.toString(), name: "uploadImage");
      rethrow;
    }
  }

  Future downloadAnImage(
      {required String imageAddress,
      required Function(int count, int total) onReceiveProgress}) async {
    final path = (await getApplicationSupportDirectory()).path + imageAddress;
    log(path);
    try {
      final response = await dio.download(
          "$baseUrl/$imageAddress",
          // path to save downloaded file
          path,

          // to get the download progress
          onReceiveProgress: onReceiveProgress);
      if (response.statusCode == 200) {
      } else {
        throw Exception("unknown Exception");
      }
    } on DioException catch (e) {
      log(e.toString(), name: "uploadimage");
      rethrow;
    } catch (e) {
      log(e.toString(), name: "uploadImage");
      rethrow;
    }
  }
}
