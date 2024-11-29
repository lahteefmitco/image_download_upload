import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_download_upload/repositories/image_download_and_uplad_repository.dart';
import 'package:image_download_upload/screens/splash_screen/splash_screen.dart';

const String baseUrl = "https://node-backend-40ct.onrender.com";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Provide Dio
        RepositoryProvider(
          create: (context) => Dio(
            BaseOptions(
              // set base url
              baseUrl: baseUrl,
            ),
          ),
        ),

        // provide ImageDownloadAndUploadRepository
        RepositoryProvider(
          create: (context) =>
              ImageDownloadAndUpladRepository(dio: context.read<Dio>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreenMaster(),
      ),
    );
  }
}
