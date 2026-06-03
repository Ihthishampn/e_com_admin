import 'package:e_com_admin/firebase_options.dart';
import 'package:e_com_admin/general/services/go_route/route_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);

  runApp(const EcomAdminApp());
}
class EcomAdminApp extends StatelessWidget {
  const EcomAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        routerConfig: RouteConfig.router,
        debugShowCheckedModeBanner: false,
        title: 'E-commerce Test Admin',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
      ),
    );
  }
}
