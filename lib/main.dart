import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_bloc.dart';
import 'package:todo/feature/presentation/bloc/task/task_event.dart';
import 'package:todo/feature/presentation/screens/login_page.dart';
import 'package:todo/feature/presentation/screens/main_screen_todo.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/service_locator.dart';
import 'package:todo/todo_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await init();
  runApp(const MyApp());
}

Future<void> _initializeFirebase() {
  return Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  static final _navigator = TodoNavigator();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider<TasksBloc>(
          create: (context) => sl<TasksBloc>()..add(GetTasks()),
        ),
      ],
      child: MaterialApp(
        routes: _navigator.routes,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) =>
              snapshot.hasData ? const TodoMainScreen() : LoginPage(),
        ),
      ),
    );
  }
}
