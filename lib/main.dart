import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/models/modeltask.dart';
import 'package:to_do_app/views/home/homeview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/database/hive_db.dart';
Future<void> main() async {
  //initial hive db
  await Hive.initFlutter();

  //register hive adapter
  Hive.registerAdapter<modeltask>(modeltaskAdapter());

  //openbox
  var box = await Hive.openBox<modeltask>("modeltaskbox");

  //delete data from previous day
  //ignore:avoid function literals in foreach calls

  box.values.forEach((task) {
    if (task.createdattime.day != DateTime.now().day) {
      task.delete();
    } else {}
  });

  runApp(MainWidget(child: Myapp()));
}

class MainWidget extends InheritedWidget {
  MainWidget({Key? key, required this.child}) : super(key: key, child: child);
   final HiveDB dataStore = HiveDB();
  final Widget child;

  static MainWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<MainWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError("Could not find ancestor widget of type MainWidget");
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Hive Todo App",
      theme: ThemeData(
        textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.black,
              fontSize: 45,
              fontWeight: FontWeight.bold,
            ),
            subtitle1: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
            headline2: TextStyle(
              color: Colors.white,
              fontSize: 21,
            ),
            headline3: TextStyle(
              color: Color.fromARGB(255, 234, 232, 232),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            headline4: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            headline5: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            subtitle2: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            headline6: TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.w300,
            )),
      ),
      home: HomeView(),
    );
  }
}
