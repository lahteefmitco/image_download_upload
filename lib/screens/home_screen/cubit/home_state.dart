part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeScrenBuildStates extends HomeState {
  final bool showProgressBar;

  final File? file;

  HomeScrenBuildStates({required this.showProgressBar, required this.file});
}

final class HomeScrenListenerStates extends HomeState {
  final String? errorMessage;
  final String? imageName;

  HomeScrenListenerStates({required this.errorMessage,required this.imageName});
}
