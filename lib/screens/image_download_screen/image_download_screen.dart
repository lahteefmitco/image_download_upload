import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_download_upload/main.dart';
import 'package:image_download_upload/repositories/image_download_and_uplad_repository.dart';
import 'package:image_download_upload/screens/image_download_screen/cubit/image_download_cubit.dart';

class ImageDownloadScreenMaster extends StatelessWidget {
  final String imageAddress;
  const ImageDownloadScreenMaster({super.key, required this.imageAddress});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ImageDownloadCubit(context.read<ImageDownloadAndUpladRepository>()),
      child: ImageDownloadScreen(
        imageAddress: imageAddress,
      ),
    );
  }
}

class ImageDownloadScreen extends StatefulWidget {
  final String imageAddress;

  const ImageDownloadScreen({super.key, required this.imageAddress});

  @override
  State<ImageDownloadScreen> createState() => _ImageDownloadScreenState();
}

class _ImageDownloadScreenState extends State<ImageDownloadScreen> {
  bool _showProgressBar = false;

  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageDownloadCubit, ImageDownloadState>(
      listenWhen: (prev, cur) {
        return cur is ImageDownloadListenerState;
      },
      listener: (context, state) {
        if (state is ImageDownloadListenerState) {
          final message = state.message;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      },
      buildWhen: (prev, cur) {
        return cur is ImageDownloadBuildState;
      },
      builder: (context, state) {
        if (state is ImageDownloadBuildState) {
          _showProgressBar = state.showProgressBar;
          _progress = state.progress;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Image Dwonload"),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Text("Progress $_progress"),
                    const SizedBox(
                      height: 24,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            "$baseUrl/${widget.imageAddress}",
                            width: 200,
                            height: 300,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // download image
                              context
                                  .read<ImageDownloadCubit>()
                                  .downloadImage(widget.imageAddress);
                            },
                            child: const Text("Download"),
                          )
                        ],
                      ),
                    )
                    // To show image
                  ],
                ),
              ),
              if (_showProgressBar) const CircularProgressIndicator()
            ],
          ),
        );
      },
    );
  }
}
