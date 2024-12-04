import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_download_upload/repositories/image_download_and_uplad_repository.dart';

part 'image_download_state.dart';

class ImageDownloadCubit extends Cubit<ImageDownloadState> {
  final ImageDownloadAndUpladRepository imageDownloadAndUpladRepository;
  ImageDownloadCubit(this.imageDownloadAndUpladRepository)
      : super(ImageDownloadInitial());

  void downloadImage(String imageAddress) async {
    try {
      emit(ImageDownloadBuildState(showProgressBar: true));
      await imageDownloadAndUpladRepository.downloadAnImage(
        imageAddress: imageAddress,
        onReceiveProgress: (count, total) {
          final percentage = ((count / total) * 100).toInt();
          log(percentage.toString(),name: "download");
          emit(ImageDownloadBuildState(showProgressBar: true,progress: percentage));
        },
      );
      emit(ImageDownloadBuildState(showProgressBar: false,progress: 100));
      emit(ImageDownloadListenerState(message: "Downloaded"));
    } catch (e) {
      emit(ImageDownloadBuildState(showProgressBar: false));
      emit(ImageDownloadListenerState(message: e.toString()));
    }
  }
}
