import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get.dart';
import 'package:group_chat/chat/v_dm_page.dart';
import 'package:group_chat/shared/data_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    injectDependencies();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instrapound',
      useInheritedMediaQuery: true,
      locale: const Locale('en', 'EN'),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Get.to(() => DMPage());
              },
              child: Text("Start Chat Room")),
        ),
      ),
    );
  }

  void injectDependencies() {
    Get.put(DataController());
  }
}
