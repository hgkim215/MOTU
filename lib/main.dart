import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:motu/provider/scenario_service.dart';
import 'package:motu/firebase_options.dart';
import 'package:motu/provider/terminology_quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:motu/view/login/login.dart';
import 'package:motu/provider/navigation_provider.dart';
import 'package:motu/provider/chat_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScenarioService()),
        ChangeNotifierProvider(create: (context) => ChatService()),
        ChangeNotifierProvider(create: (context) => NavigationService()),
        ChangeNotifierProvider(create: (_) => TerminologyQuizService()),
      ],
      builder: (context, child) => const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
