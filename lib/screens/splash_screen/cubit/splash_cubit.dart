import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_download_upload/repositories/image_download_and_uplad_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final ImageDownloadAndUpladRepository imageDownloadAndUpladRepository;
  SplashCubit(this.imageDownloadAndUpladRepository) : super(SplashInitial());

  void getWelcomeMessage() async {
    try {
      emit(SplashBuildState(showProgressBar: true, welcomeMessage: ""));
      final welcomeMessage =
          await imageDownloadAndUpladRepository.getWelcomeMessage();
      emit(SplashBuildState(
          showProgressBar: false, welcomeMessage: welcomeMessage));
      await Future.delayed(const Duration(seconds: 5));
      emit(SplashListenerState(errorMessage: null, navigateToHomeScreen: true));
    } catch (e) {
      emit(SplashBuildState(
          showProgressBar: false, welcomeMessage: e.toString()));
      emit(SplashListenerState(
          errorMessage: e.toString(), navigateToHomeScreen: false));
    }
  }


  
  @override
  Future<void> close() {
    log("Closed");
    return super.close();
  }
}
