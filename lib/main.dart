import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Añade esta importación
import 'providers/bluetooth_provider.dart'; // Asegúrate de crear este archivo
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      // Envuelve toda la app con MultiProvider
      providers: [ChangeNotifierProvider(create: (_) => BluetoothProvider())],
      child: SignLanguageApp(),
    ),
  );
}

class SignLanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Language Translator',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
