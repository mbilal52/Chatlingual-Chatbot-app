import 'package:chatgpt_app/Utils/Routes.dart';
import 'package:chatgpt_app/firebase_options.dart';
import 'package:chatgpt_app/providers/language_change_provider.dart';
import 'package:chatgpt_app/providers/loading_provider.dart';
import 'package:chatgpt_app/providers/models_provider.dart';
import 'package:chatgpt_app/screens/SignupScreen.dart';
import 'package:chatgpt_app/screens/homePage.dart';
import 'package:chatgpt_app/screens/loginScreen.dart';
import 'package:chatgpt_app/screens/splash_screen.dart';
import 'package:chatgpt_app/screens/translator_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/const.dart';
import 'providers/chats_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageChangeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoadingProvider(),
        ),
      ],
      child: Consumer<LanguageChangeProvider>(
          builder: (context, provider, child){
        return MaterialApp(
          title: 'ChatGPT',
          // localizationsDelegates: context.localizationDelegates,
          // supportedLocales: context.supportedLocales,
          // locale: provider.appLocale,
          locale: provider.appLocale,
          localizationsDelegates: const[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const[
            Locale('en'),
            Locale('sd'),
            Locale('ur')
          ],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: scaffoldBackgroundColor,
              appBarTheme: AppBarTheme(
                color: cardColor,
              )),
          home: const HomePage(),
          initialRoute: Routes.splashscreen,
          routes: {
            '/splashscreen': (context) => const SplashScreen(),
            '/home': (context) => const HomePage(),
            'login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/translatorscreen' : (context) => const TranslatorScreen()
            // '/chat': (context) => ChatScreen(),
          },
        );
      })
    );
  }
}
