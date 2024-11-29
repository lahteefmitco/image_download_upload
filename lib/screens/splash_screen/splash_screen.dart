import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_download_upload/repositories/image_download_and_uplad_repository.dart';
import 'package:image_download_upload/screens/home_screen/home_screen.dart';
import 'package:image_download_upload/screens/splash_screen/cubit/splash_cubit.dart';

class SplashScreenMaster extends StatelessWidget {
  const SplashScreenMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashCubit(context.read<ImageDownloadAndUpladRepository>())
            ..getWelcomeMessage(),
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashState>(
      listenWhen: (prev, cur) {
        return cur is SplashListenerState;
      },
      listener: (context, state) {
        if (state is SplashListenerState) {
          final errorMessage = state.errorMessage;
          final navigate = state.navigateToHomeScreen;

          if (errorMessage != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(errorMessage)));
          }

          if (navigate) {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomeScreenMaster()));
          }
        }
      },
      buildWhen: (prev, cur) {
        return cur is SplashBuildState;
      },
      builder: (context, state) {
        String welcomeMessage = "";
        bool showProgressBar = false;
        if (state is SplashBuildState) {
          welcomeMessage = state.welcomeMessage;
          showProgressBar = state.showProgressBar;
        }
        return Scaffold(
            body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(welcomeMessage),
            ),
            if (showProgressBar) const CircularProgressIndicator()
          ],
        ));
      },
    );
  }
}
