import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/Providers/AuthProvide/authProvide.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';
import 'package:xap_vpn/Screens/Onborading/Splash.dart';
import 'package:xap_vpn/Screens/vpnScreen/button.dart';
import 'package:xap_vpn/Screens/vpnScreen/new.dart';
// import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvide()),
        ChangeNotifierProvider(create: (_) => VpnProvide()),
      ],
      child: GetMaterialApp(
        title: 'Xap VPN',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF0B5C8C),
          scaffoldBackgroundColor: Colors.transparent,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF0B5C8C),
            background: Colors.transparent,
            surface: Colors.white,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF0B5C8C),
          scaffoldBackgroundColor: Color.fromARGB(255, 10, 18, 30),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF0B5C8C),
            background: Color(0xFF121212),
            surface: Color(0xFF1E1E1E),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
