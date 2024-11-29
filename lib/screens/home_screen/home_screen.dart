import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_download_upload/repositories/image_download_and_uplad_repository.dart';
import 'package:image_download_upload/screens/home_screen/cubit/home_cubit.dart';
import 'package:image_download_upload/screens/image_download_screen/image_download_screen.dart';

class HomeScreenMaster extends StatelessWidget {
  const HomeScreenMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
          imageDownloadAndUpladRepository:
              context.read<ImageDownloadAndUpladRepository>()),
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _file;

  bool _showProgressBar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (prev, cur) {
          return cur is HomeScrenListenerStates;
        },
        listener: (context, state) {
          log("listening");
          if (state is HomeScrenListenerStates) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }

            if (state.imageName != null) {

              // Navigate to Image display and download screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ImageDownloadScreenMaster(imageAddress: state.imageName!)));
            }
          }
        },
        buildWhen: (prev, cur) {
          return cur is HomeScrenBuildStates;
        },
        builder: (context, state) {
          log("building");
          if (state is HomeScrenBuildStates) {
            _file = state.file;
            _showProgressBar = state.showProgressBar;
          }
          return Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        context.read<HomeCubit>().pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent),
                      child: const Text("Pick Image"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (_file != null)
                      Column(
                        children: [
                          Image.file(
                            _file!,
                            width: 300,
                            height: 400,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeCubit>().uploadAnImage(_file!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Upload"),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              if (_showProgressBar) const CircularProgressIndicator()
            ],
          );
        },
      ),
    );
  }
}
