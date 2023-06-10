import 'package:flutter/material.dart';
import 'views/Summary.dart';
import 'views/Calendar.dart';
import 'views/Masters.dart';
import 'views/Master.dart';
import 'views/Tasks.dart';
import 'views/Task.dart';
import 'views/User.dart';
import 'package:provider/provider.dart';
import '../features/MasterData.dart';
import '../features/TaskData.dart';
import '../features/SummaryData.dart';
import '../features/CalendarData.dart';
import '../features/UserData.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MasterData()),
        ChangeNotifierProvider(create: (context) => TaskData()),
        ChangeNotifierProvider(create: (context) => SummaryData()),
        ChangeNotifierProvider(create: (context) => MasterEditModel()),
        ChangeNotifierProvider(create: (context) => TaskEditModel()),
        ChangeNotifierProvider(create: (context) => CalendarModel()),
        ChangeNotifierProvider(create: (context) => UserDataModel()),
        // Provider(create: (context) => ApiData()),
      ],
      child: const MyApp(),
    ),
  );
}

// final _user = FirebaseAuth.instance.currentUser;
// final GoRouter _router = GoRouter(
//   routes: [
//     GoRoute(path: '/', builder: (context, state) => const SummaryView()),
//     GoRoute(path: '/calendar', builder: (context, state) => const CalendarView()),
//     GoRoute(path: '/masters', builder: (context, state) => const MastersView()),
//     GoRoute(path: '/tasks', builder: (context, state) => const TasksView()),
//     GoRoute(path: '/master', builder: (context, state) => const MasterView()),
//     GoRoute(path: '/task', builder: (context, state) => const TaskView()),
//     GoRoute(path: '/user', builder: (context, state) => const UserView()),
//   ],
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp.router(
    //   title: 'Housework Manager',
    //   theme: ThemeData(
    //     primarySwatch: Colors.orange,
    //     fontFamily: 'NotoSansJP',
    //   ),
    //   routerDelegate: _router.routerDelegate,
    //   routeInformationParser: _router.routeInformationParser,
    // );
    // final _user = FirebaseAuth.instance.currentUser;
    // if (_user == null) {
    //   Navigator.of(context).pushNamed('/user');
    // }
    return MaterialApp(
        title: 'Housework Manager',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'NotoSansJP',
        ),
        routes: {
          '/': (context) => const SummaryView(),
          '/calendar': (context) => const CalendarView(),
          '/masters': (context) => const MastersView(),
          '/tasks': (context) => const TasksView(),
          '/master': (context) => const MasterView(),
          '/task': (context) => const TaskView(),
          '/user': (context) => const UserView(),
        }
    );
    // localizationsDelegates: [
    //   GlobalMaterialLocalizations.delegate,
    //   GlobalWidgetsLocalizations.delegate,
    // ],
    // supportedLocales: [
    //   const Locale("en"),
    //   const Locale("ja"),
    // ],
  }
}
