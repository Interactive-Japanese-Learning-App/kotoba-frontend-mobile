import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/camera/bindings/camera_binding.dart';
import '../modules/camera/views/camera_view.dart';
import '../modules/canvas/bindings/canvas_binding.dart';
import '../modules/canvas/views/canvas_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/nihongo/bindings/nihongo_binding.dart';
import '../modules/nihongo/views/nihongo_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/edit_profile.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/quiz/bindings/quiz_binding.dart';
import '../modules/quiz/views/quiz_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/speech/bindings/speech_binding.dart';
import '../modules/speech/views/speech_detail_view.dart';
import '../modules/speech/views/speech_view.dart';
import '../modules/welcome/bindings/welcome_binding.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../modules/writing/bindings/writing_binding.dart';
import '../modules/writing/views/writing_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.WELCOME;

  static final routes = [
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/profile/edit',
      page: () => const EditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA,
      page: () => const CameraView(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: _Paths.NIHONGO,
      page: () => const NihongoView(),
      binding: NihongoBinding(),
    ),
    GetPage(
      name: _Paths.WRITING,
      page: () => const WritingView(),
      binding: WritingBinding(),
    ),
    GetPage(
      name: _Paths.CANVAS,
      page: () => const CanvasView(),
      binding: CanvasBinding(),
    ),
    GetPage(
      name: _Paths.SPEECH,
      page: () => const SpeechView(),
      binding: SpeechBinding(),
    ),
    GetPage(
      name: Routes.SPEECH_DETAIL,
      page: () => const SpeechDetailView(),
      binding: SpeechBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: Routes.QUIZ_LEVEL,
      page: () => Scaffold(body: Center(child: Text("Quiz Level"))),
    ),

    GetPage(
      name: Routes.QUIZ_QUESTION,
      page: () => Scaffold(body: Center(child: Text("Quiz Question"))),
    ),
  ];
}
