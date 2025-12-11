import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Apple.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Banana.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Basil.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Bougainvilea.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Broccoli.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Cabbage.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Carrot.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Eggplant.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Garlic.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Jasmine.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Mango.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Mint.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Moringa.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Parsley.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Pomegranate.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Potato.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/Sage.dart';
import 'package:plantpal_2025/PlantsDetailsScreens/dill.dart';
import 'package:plantpal_2025/app_settings_page.dart';
import 'package:plantpal_2025/remove_block_users.dart';
import 'package:plantpal_2025/send_notification_page.dart';
import 'package:plantpal_2025/send_reminder_page.dart';
import 'package:plantpal_2025/thank_you_page.dart';
import 'package:plantpal_2025/update_delete_page.dart';
import 'package:plantpal_2025/view_activity_logs.dart';
import 'package:plantpal_2025/view_all_users.dart';
import 'package:plantpal_2025/view_notification_history.dart';

import 'PlantsDetailsScreens/Date_Palm.dart';
import 'PlantsDetailsScreens/Desert_Rose.dart';
import 'PlantsDetailsScreens/Tomato.dart';
import 'home_page.dart';
import 'options_page.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';
import 'forgot_password_page.dart';
import 'admin_login_page.dart';
import 'admin_page.dart';
import 'plants_page.dart';
import 'add_plant_page.dart';
import 'edit_plant_page.dart';
import 'auth_home_page.dart';
import 'services.dart';
import 'comments_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PlantsApp());
}

class PlantsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plants App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName:          (_) => HomePage(),
        OptionsPage.routeName:       (_) => OptionsPage(),
        SignInPage.routeName:        (_) => SignInPage(),
        SignUpPage.routeName:        (_) => SignUpPage(),
        //'/DillInfoPage': (context) => const DillInfoPage(),
        //'/ThankYouPage': (context) => const ThankYouPage(),
        '/Dill': (context) => const Dill(),
        '/DesertRose': (context) => const DesertRose(),
        '/Tomato': (context) => const Tomato(),
        '/DatePalm': (context) => const DatePalm(),
        '/Apple': (context) => const Apple(),
        '/Basi': (context) => const Basil(),
        '/Banana': (context) => const Banana(),
        '/Bougainvillea': (context) => const Bougainvillea(),
        '/Broccoli': (context) => const Broccoli(),
        '/Cabbage': (context) => const Cabbage(),
        '/Carrot': (context) => const Carrot(),
        '/Eggplant': (context) => const Eggplant(),
        '/Garlic': (context) => const Garlic(),
        '/Jasmine': (context) => const Jasmine(),
        '/Mango': (context) => const Mango(),
        '/Mint': (context) => const Mint(),
        '/Moringa': (context) => const Moringa(),
        '/Parsley': (context) => const Parsley(),
        '/Potato': (context) => const DatePalm(),
        '/Pomegranate': (context) => const Pomegranate(),
        '/Sage': (context) => const Sage(),
        //DillInfoStaticPage.routeName: (context) => const DillInfoStaticPage(),
        //ForgotPasswordScreen.routeName:(_) => ForgotPasswordScreen(),
        AdminLoginPage.routeName:    (_) => AdminLoginPage(),
        AdminPage.routeName:         (_) => AdminPage(),
        PlantsPage.routeName:        (_) => PlantsPage(),
        ThankYouPage.routeName: (context) => ThankYouPage(),
        AddPlantPage.routeName:      (_) => AddPlantPage(),
        UpdateDeletePage.routeName:      (_) => UpdateDeletePage(),
        ViewAllUsersPage.routeName:      (_) => ViewAllUsersPage(),
        ManageUsersPage.routeName:      (_) => ManageUsersPage(),
        SendNotificationPage.routeName:      (_) => SendNotificationPage(),
        ViewNotificationHistoryPage.routeName:      (_) => ViewNotificationHistoryPage(),
        ViewActivityLogsPage.routeName: (_) => const ViewActivityLogsPage(),
        SendReminderPage.routeName:    (_) => SendReminderPage(),
        EditPlantPage.routeName:     (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;
          final plant = args['plant'] as Plant;
          final ownerUid = args['ownerUid'] as String;
          return EditPlantPage(plant: plant, ownerUid: ownerUid);
        },
        AuthHomePage.routeName:      (_) => AuthHomePage(),
        CommentsPage.routeName:      (_) => CommentsPage(),
      },
    );
  }
}
