part of 'image_download_cubit.dart';

@immutable
sealed class ImageDownloadState {}

final class ImageDownloadInitial extends ImageDownloadState {}

final class ImageDownloadListenerState extends ImageDownloadState {
  final String message;

  ImageDownloadListenerState({required this.message});
}

final class ImageDownloadBuildState extends ImageDownloadState {
  final bool showProgressBar;
  final double progress;

  ImageDownloadBuildState({required this.showProgressBar,this.progress = 0});
}
