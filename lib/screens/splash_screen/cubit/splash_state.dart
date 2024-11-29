part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashListenerState extends SplashState {
  final String? errorMessage;
  final bool navigateToHomeScreen;

  SplashListenerState(
      {required this.errorMessage, required this.navigateToHomeScreen});
}

final class SplashBuildState extends SplashState {
  final bool showProgressBar;
  final String welcomeMessage;

  SplashBuildState(
      {required this.showProgressBar, required this.welcomeMessage});
}
