import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/learn_controller.dart';

class LearnView extends GetView<LearnController> {
  const LearnView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LearnView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LearnView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
