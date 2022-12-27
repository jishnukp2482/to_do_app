
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:to_do_app/main.dart';
import 'package:to_do_app/models/modeltask.dart';
import 'package:to_do_app/utilits/colors.dart';
import 'package:to_do_app/utilits/constanst.dart';
import 'package:to_do_app/utilits/mystrings.dart';
import 'package:to_do_app/views/home/homeview.dart';
import 'package:to_do_app/database/hive_db.dart';
import 'package:to_do_app/views/home/widgets/taskwidget.dart';
import 'package:to_do_app/views/tasks/taskview.dart';







class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library private types in public api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  // Checking done tasks
  int checkDoneTask(List<modeltask> task) {
    int i = 0;
    for (modeltask doneTasks in task) {
      if (doneTasks.iscompleted) {
        i++;
      }
    }
    return i;
  }

  // Checking the value of the circle indicator
  dynamic valueOfTheIndicator(List<modeltask> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = MainWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listentotask(),
        builder: (ctx, Box<modeltask> box, Widget? child) {
          var tasks = box.values.toList();

          //sort task list
          tasks.sort(((a, b) => a.createdatdate.compareTo(b.createdatdate)));

          return Scaffold(
            backgroundColor: Colors.white,

            // floating action button
            floatingActionButton: const FAB(),

            // body
            body: SliderDrawer(
              isDraggable: false,
              key: dKey,
              animationDuration: 500,

              // myappbar
              appBar: MyAppBar(
                drawerKey: dKey,
              ),

              // my drawer slider
              slider: MySlider(),

              /// main body
              child: _buildBody(
                tasks,
                base,
                textTheme,
              ),
            ),
          );
        });
  }

  // main body
  SizedBox _buildBody(
    List<modeltask> tasks,
    MainWidget base,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // top section Of home page : text, Progrss indicator
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // circularprogressindicator
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    valueColor:  AlwaysStoppedAnimation(mycolor.primarycolor),
                    backgroundColor: Colors.red.shade500,
                    value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),

                // texts
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mystring.maintitle, style: textTheme.headline1),
                    const SizedBox(
                      height: 3,
                    ),
                    Text("${checkDoneTask(tasks)} of ${tasks.length} task",
                        style: textTheme.subtitle1),
                  ],
                )
              ],
            ),
          ),

          // divider
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              color: Color.fromARGB(255, 136, 246, 215),
              thickness: 2,
              indent: 100,
            ),
          ),

          // bottom listView : tasks
          SizedBox(
            width: double.infinity,
            height: 500,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      var task = tasks[index];

                      return Dismissible(
                        direction: DismissDirection.horizontal,
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(mystring.deletedtask,
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                        onDismissed: (direction) {
                          base.dataStore.deletetask(task: task);
                        },
                        key: Key(task.id),
                        child: TaskWidget(
                          task: tasks[index],
                        ),
                      );
                    },
                  )

                // if all tasks done show this widgets
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // lottie
                      FadeIn(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Lottie.asset(
                            'assets/lottie/1.json',
                            animate: tasks.isNotEmpty ? false : true,
                          ),
                        ),
                      ),

                      /// Bottom Texts
                      FadeInUp(
                        from: 30,
                        child:
                            Text(mystring.donealltask),
                            

                         
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

/// My Drawer Slider
class MySlider extends StatelessWidget {
  MySlider({
    Key? key,
  }) : super(key: key);

  /// Icons
  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration:  BoxDecoration(
        gradient:
         LinearGradient(
            colors: mycolor.primarygradientcolor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/accownerimg.jpg'),
          ),
          const SizedBox(
            height: 8,
          ),
          Text("Jishnu kp", style: textTheme.headline2),
          Text("Flutter Developer", style: textTheme.headline3),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                itemCount: icons.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return InkWell(
                    // ignore: avoid_print
                    onTap: () => print("$i Selected"),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                          leading: Icon(
                            icons[i],
                            color: Colors.white,
                            size: 30,
                          ),
                          title: Text(
                            texts[i],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

/// My App Bar
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  MyAppBar({Key? key, 
    required this.drawerKey,
  }) : super(key: key);
  GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// toggle for drawer and icon aniamtion
  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = MainWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 132,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Animated Icon - Menu & Close
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: controller,
                    size: 30,
                  ),
                  onPressed: toggle),
            ),

            /// Delete Icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  base.isEmpty
                      ? warningnotask(context)
                      : deletealltask(context);
                },
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating Action Button
class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
     
        child:
           CircleAvatar(
            radius: 35,
            backgroundColor: mycolor.primarycolor,
             child: const Center(
                child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
                     )),
           ),
        
      
    );
  }
}