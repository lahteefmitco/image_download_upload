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
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Image Dwonload"),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  // To show image
                  Image.network("$baseUrl/${widget.imageAddress}"),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {

                      // download image
                      context.read<ImageDownloadCubit>().downloadImage(widget.imageAddress);
                    },
                    child: const Text("Download"),
                  )
                ],
              ),
              if (_showProgressBar) const CircularProgressIndicator()
            ],
          ),
        );
      },
    );
  }
}
