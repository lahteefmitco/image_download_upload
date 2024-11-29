import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_download_upload/repositories/image_download_and_uplad_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ImageDownloadAndUpladRepository imageDownloadAndUpladRepository;
  HomeCubit({required this.imageDownloadAndUpladRepository})
      : super(HomeInitial());

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // multiple images are not allowed
      allowMultiple: false,

      // only selects images
      type: FileType.image,
    );

    if (result != null) {
      emit(
        HomeScrenBuildStates(
          showProgressBar: false,
         
          file: File(result.files.first.path!),
        ),
      );
    }
  }

  void uploadAnImage(File file) async {
    emit(HomeScrenBuildStates(
        showProgressBar: true, file: file, ));
    try {
      final imageName = await imageDownloadAndUpladRepository.uploadAnImage(file);
      emit(HomeScrenBuildStates(
          showProgressBar: false, file: null, ));
      emit(HomeScrenListenerStates(errorMessage: "Image uploaded succesfully",imageName: imageName));
    } catch (e) {
      log(e.toString());
      emit(HomeScrenBuildStates(
          showProgressBar: false, file: file, ));
      emit(HomeScrenListenerStates(errorMessage: e.toString(),imageName: null));
    }
  }
}
