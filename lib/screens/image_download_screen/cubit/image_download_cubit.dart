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
      await imageDownloadAndUpladRepository.downloadAnImage(imageAddress);
      emit(ImageDownloadBuildState(showProgressBar: false));
      emit(ImageDownloadListenerState(message: "Downloaded"));
    } catch (e) {
      emit(ImageDownloadBuildState(showProgressBar: false));
      emit(ImageDownloadListenerState(message: e.toString()));
    }
  }
}
